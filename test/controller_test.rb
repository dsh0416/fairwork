# frozen_string_literal: true
require "test_helper"

require 'action_controller/railtie'
require 'logger'

Rails.logger = Logger.new(STDOUT)

class App < ::Rails::Application
  config.eager_load = false
  config.hosts << 'example.org'
  routes.append do
    root to: 'root#index'
    get '/initialize', to: 'root#fairwork_initialize'
  end
end

class RootController < ActionController::Base
  include Fairwork::Controller

  before_action :prepend_view_paths
  before_action :fairwork_validate, except: :fairwork_initialize

  def prepend_view_paths
    prepend_view_path "#{__dir__}/views"
  end

  def index
    render plain: 'pass'
  end
end

Fairwork::Configure.redis = MockRedis.new
App.initialize!

class ControllerTest < Minitest::Test
  include Rack::Test::Methods

  def app
    builder = Rack::Builder.new
    builder.run App
  end

  def test_not_pass_if_not_initialized
    get '/'
    assert_equal 500, last_response.status
  end

  def test_not_pass_if_initialized_but_no_pow
    get '/initialize'
    assert_equal 200, last_response.status
    get '/'
    assert_equal 500, last_response.status
  end

  def test_legal_request
    get '/initialize'
    assert_equal 200, last_response.status
    iv = JSON.parse(last_response.body)['fairwork_iv']
    pow = Fairwork::PoW.new(iv)
    nounce, timestamp, uniq_ctr = pow.solve('GET', '/', 4)
    get "/", fairwork_nounce: nounce, fairwork_timestamp: timestamp, fairwork_uniq_ctr: uniq_ctr
    assert_equal 200, last_response.status
  end
end

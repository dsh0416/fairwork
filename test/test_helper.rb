# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "simplecov"
SimpleCov.start do
  track_files '{lib}/**/*.rb'
  add_filter "/test/"
end

require "minitest/autorun"
require "minitest/benchmark"
require "minitest/reporters"
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new()]
require "fairwork"

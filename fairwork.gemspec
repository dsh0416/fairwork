require_relative 'lib/fairwork/version'

Gem::Specification.new do |spec|
    spec.name          = "fairwork"
    spec.version       = Fairwork::VERSION
    spec.platform      = Gem::Platform::RUBY
    spec.authors       = ["Delton Ding"]
    spec.email         = ["dsh0416@gmail.com"]
  
    spec.summary       = ""
    spec.description   = ""
    spec.homepage      = "https://github.com/dsh0416/fairwork"
    spec.license       = 'MIT'
    spec.required_ruby_version = '>= 3.0.0'
  
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/dsh0416/fairwork"
  
    spec.files         = Dir["{lib}/**/*", "LICENSE", "README.md"]
    spec.require_paths = ["lib"]

    spec.add_runtime_dependency 'redis', '~> 4.6'

    spec.add_development_dependency 'rails', '~> 7.0'
    spec.add_development_dependency 'tzinfo-data' # This is a MUST on windows
    spec.add_development_dependency 'rack-test', '~> 1.1'
    spec.add_development_dependency 'simplecov', '~> 0.20.0'
    spec.add_development_dependency 'minitest-reporters', '~> 1.4'
    spec.add_development_dependency 'mock_redis', '~> 0.29'
  end

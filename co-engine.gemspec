# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'co_engine/version'

Gem::Specification.new do |spec|
  spec.name          = "co_engine"
  spec.version       = CoEngine::VERSION
  spec.authors       = ["David Henry"]
  spec.email         = ["dw_henry@yahoo.com.au"]
  spec.summary       = %q{Game Engine}
  spec.description   = %q{Game Engine for the code breaker game}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
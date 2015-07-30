# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'MShealth/version'

Gem::Specification.new do |spec|
  spec.name          = "MShealth"
  spec.version       = MShealth::VERSION
  spec.authors       = ["WH Lu"]
  spec.email         = ["luwh364@gmail.com"]

  spec.summary       = "Ruby API wrapper for the Microsoft Health Cloud"
  spec.description   = "Ruby API wrapper for the Microsoft Health Cloud"
  spec.homepage      = "https://github.com/yielder/mshealth"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty"
  spec.add_dependency "hashie"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end

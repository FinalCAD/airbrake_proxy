# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'airbrake_proxy/version'

Gem::Specification.new do |spec|
  spec.name          = "airbrake_proxy"
  spec.version       = AirbrakeProxy::VERSION
  spec.authors       = ["Joel AZEMAR"]
  spec.email         = ["joel.azemar@gmail.com"]

  spec.summary       = %q{Basic Circuit Breaker for Airbrake}
  spec.description   = %q{Basic Circuit Breaker to attempt not reach Airbrake limit for the same exception}
  spec.homepage      = "https://github.com/FinalCAD/airbrake_proxy"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "airbrake", "~> 5.6"
  spec.add_development_dependency "activesupport", "~> 4.2"
  spec.add_development_dependency "time_constants", "~> 0.2"
  spec.add_development_dependency "redis", "~> 3.3"
end

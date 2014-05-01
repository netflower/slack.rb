# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slack/version'

Gem::Specification.new do |spec|
  spec.name          = "slack"
  spec.version       = Slack::VERSION
  spec.authors       = ["Bastian Bartmann", "Mathias Bartmann"]
  spec.email         = ["bastian.bartmann@netflower.de", "mathias.bartmann@netflower.de"]
  spec.summary       = %q{Simple wrapper for the Slack API}
  spec.description   = %q{Ruby toolkit for working with the Slack API}
  spec.homepage      = "https://github.com/netflower/slack"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.9.0"
  spec.add_development_dependency 'bundler', '~> 1.5'
end

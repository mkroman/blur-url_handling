# encoding: utf-8

Gem::Specification.new do |spec|
  spec.name     = "blur-url_handling"
  spec.version  = '0.1'
  spec.summary  = "Adds a URL-handling framework to Blur scripts"

  spec.homepage = "https://github.com/mkroman/blur-url_handling"
  spec.license  = "MIT"
  spec.author   = "Mikkel Kroman"
  spec.email    = "mk@maero.dk"
  spec.files    = Dir["library/**/*.rb", "README.md", "LICENSE"]

  spec.add_runtime_dependency 'blur', '~> 2.0'

  spec.require_path = "library"
  spec.required_ruby_version = ">= 1.9.1"
end

# vim: set syntax=ruby:

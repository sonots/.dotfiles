# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'skel/version'

Gem::Specification.new do |spec|
  spec.name          = "skel"
  spec.version       = Skel::VERSION
  spec.authors       = ["Naotoshi Seo"]
  spec.email         = ["sonots@gmail.com"]
  spec.description   = %q{Skelton}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/sonots/skel"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "rake"

  # spec.add_runtime_dependency 'fluentd'
end

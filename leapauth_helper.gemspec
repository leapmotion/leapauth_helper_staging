# -*- encoding: utf-8 -*-
require File.expand_path('../lib/leapauth_helper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Josh Hull", "Mr Rogers"]
  gem.email         = ["jhull@leapmotion.com", "jrogers@leapmotion.com"]
  gem.description   = %q{Authentication helpers for leap auth}
  gem.summary       = %q{Authentication helpers for leap auth.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "leapauth_helper"
  gem.require_paths = ["lib"]
  gem.version       = LeapauthHelper::VERSION

  gem.add_dependency 'json', '>= 1.7'
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "activesupport", ">= 3.2.0"
end

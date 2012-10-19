# -*- encoding: utf-8 -*-
require File.expand_path('../lib/leapauth_helper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Josh Hull"]
  gem.email         = ["jhull@leapmotion.com"]
  gem.description   = %q{Authentication helpers for leap auth}
  gem.summary       = %q{Authentication helpers for leap auth.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "leapauth_helper"
  gem.require_paths = ["lib"]
  gem.version       = LeapauthHelper::VERSION

  gem.add_development_dependency "mocha"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "activesupport", ">= 3.2.0"
end

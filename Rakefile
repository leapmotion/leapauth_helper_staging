#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'

task :default => :test
Rake::TestTask.new("test") do |test|
  test.pattern = "test/**/*_test.rb"
  test.verbose = true
end

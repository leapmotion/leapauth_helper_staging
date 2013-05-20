#!/usr/bin/env rake
require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'
  
  RSpec::Core::RakeTask.new(:spec)
  
  task :default => :spec

  task :test => :spec
rescue Exception => ex
  puts "Failed to load rspec task.  Should be fine if you're not testing stuff"
end

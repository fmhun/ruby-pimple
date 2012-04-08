#!/usr/bin/env rake
require 'bundler'
Bundler::GemHelper.install_tasks

task :default => ['spec']
task :test => :spec

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
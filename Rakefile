#! /usr/bin/env ruby
require 'rake'
require 'cucumber'
require 'cucumber/rake/task'

task default: [ :build, :install, :test ]

task :build do
   sh 'gem build *.gemspec'
end

task :install do
  sh 'gem install *.gem'
end

Cucumber::Rake::Task.new(:test) do |t|
  t.cucumber_opts = %w{--format pretty}
end

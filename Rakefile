#!/usr/bin/env ruby

require 'rspec/core/rake_task'

desc "run the specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['--color', '--format documentation']
end

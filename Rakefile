require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'rspec_hue'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc "Find and print the ip of Hue"
task :hue_ip do
    Huey::Config.logger = ::Logger.new(nil)
    puts Huey::SSDP.hue_ip
end

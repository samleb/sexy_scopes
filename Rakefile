require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :cov do
  ENV['COVERAGE'] = '1'
  Rake::Task['spec'].invoke
end

task :default => :spec

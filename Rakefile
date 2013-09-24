require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'appraisal'

desc "Run specifications"
RSpec::Core::RakeTask.new(:spec)

desc "Measure test coverage"
task :cov do
  ENV['COVERAGE'] = '1'
  Rake::Task['spec'].invoke
end

task :default => :spec

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc "Run specifications"
RSpec::Core::RakeTask.new(:spec)

desc "Measure test coverage" do
  task :cov do
    ENV['COVERAGE'] = '1'
    Rake::Task['spec'].invoke
  end
end

task :default => :spec

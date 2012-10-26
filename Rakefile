require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc "Run specifications"
RSpec::Core::RakeTask.new(:spec)

desc "Measure test coverage"
if RUBY_VERSION >= '1.9'
  task :cov do
    ENV['COVERAGE'] = '1'
    Rake::Task['spec'].invoke
  end
else
  RSpec::Core::RakeTask.new(:cov) do |spec|
    spec.rcov = true
  end
end

task :default => :spec

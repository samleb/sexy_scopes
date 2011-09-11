require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sexy_scopes"
    gem.summary = %Q{Small DSL to create ActiveRecord attribute predicates without writing SQL.}
    gem.description = %Q{Small DSL to create ActiveRecord attribute predicates without writing SQL.}
    gem.email = "samuel.lebeau@gmail.com"
    gem.homepage = "http://github.com/samleb/sexy_scopes"
    gem.authors = ["Samuel Lebeau"]
    gem.add_dependency "activerecord", "~> 3.0"
    gem.add_development_dependency "rake", "~> 0.9"
    gem.add_development_dependency "jeweler", "~> 1.0"
    gem.add_development_dependency "sqlite3", "~> 1.0"
    gem.add_development_dependency "rspec", "~> 2.1"
    gem.add_development_dependency "rcov", "~> 0.9"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rcov = true
end

task :default => :spec

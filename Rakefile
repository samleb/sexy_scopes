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
    gem.add_dependency "activerecord", ">= 3.0.0.beta"
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "yard", ">= 0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

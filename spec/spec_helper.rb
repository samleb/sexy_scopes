if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

require 'rspec'
require 'active_record'
require 'sexy_scopes'

RSpec.configure do |config|
  config.extend Module.new {
    def ruby_19
      yield if ruby_19?
    end
    
    def ruby_19?
      RUBY_VERSION >= "1.9"
    end
  }
end

Dir.glob(File.join(File.dirname(__FILE__), '{fixtures,matchers}', '*')) do |file|
  require file
end

shared_examples "a predicate method" do
  it "should return an Arel node" do
    subject.class.name.should =~ /^Arel::/
  end
  
  it { should be_extended_by SexyScopes::PredicateWrappers }
end

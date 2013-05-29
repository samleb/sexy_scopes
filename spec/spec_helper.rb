if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear! do
    # exclude gems bundled by Travis
    add_filter 'ci/bundle'
  end
end

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

require 'rspec'
require 'active_record'
require 'sexy_scopes'

Dir.glob(File.join(File.dirname(__FILE__), '{fixtures,matchers}', '*')) do |file|
  require file
end

shared_examples "a predicate method" do
  it "should return an Arel node" do
    subject.class.name.should =~ /^Arel::/
  end
  
  it { should be_extended_by SexyScopes::PredicateWrappers }
end

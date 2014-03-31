if ENV['COVERAGE'] || ENV['TRAVIS']
  require 'simplecov'
  
  if ENV['TRAVIS']
    require 'coveralls'
    SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  end
  
  SimpleCov.start do
    # exclude Gemfiles and gems bundled by Travis
    add_filter 'gemfiles/'
    add_filter 'spec/'
  end
end

require 'rspec'
require 'active_record'
require 'sexy_scopes'

Dir.glob(File.join(File.dirname(__FILE__), '{fixtures,matchers}', '*')) do |file|
  require file
end

shared_examples "a predicate method" do
  it "should return an Arel node" do
    subject.class.name.should =~ /(^|SexyScopes::)Arel::Nodes::/
  end
  
  it { should be_extended_by SexyScopes::Arel::PredicateMethods }
end

shared_examples "an expression method" do
  it "should return an Arel node" do
    subject.class.name.should =~ /(^|SexyScopes::)Arel::Nodes::/
  end
  
  it { should be_extended_by SexyScopes::Arel::ExpressionMethods }
end

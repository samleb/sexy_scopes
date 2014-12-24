require 'spec_helper'

describe SexyScopes::ActiveRecord::ClassMethods do
  it "should extend ActiveRecord::Base" do
    ActiveRecord::Base.should be_extended_by described_class
  end

  describe ".attribute(name)" do
    subject { User.attribute(:username) }

    it "should return an Arel attribute for the given name" do
      subject.should == User.arel_table[:username]
    end

    it { should be_extended_by SexyScopes::Arel::ExpressionMethods }
  end

  describe ".sql_literal(expression)" do
    subject { User.sql_literal('NOW()') }

    it "should return an Arel literal for given expression" do
      subject.should == ::Arel.sql('NOW()')
    end

    it "should be aliased as `sql`" do
      described_class.instance_method(:sql).should == described_class.instance_method(:sql_literal)
    end

    it { should be_extended_by SexyScopes::Arel::ExpressionMethods }

    it { should be_extended_by SexyScopes::Arel::PredicateMethods }
  end
end

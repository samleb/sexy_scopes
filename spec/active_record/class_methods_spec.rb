require 'spec_helper'

describe SexyScopes::ActiveRecord::ClassMethods do
  it "should extend ActiveRecord::Base" do
    expect(ActiveRecord::Base).to be_extended_by described_class
  end

  describe ".attribute(name)" do
    subject { User.attribute(:username) }

    it "should return an Arel attribute for the given name" do
      is_expected.to eq User.arel_table[:username]
    end

    it { is_expected.to be_extended_by SexyScopes::Arel::ExpressionMethods }
  end

  describe ".sql_literal(expression)" do
    subject { User.sql_literal('NOW()') }

    it "should return an Arel literal for given expression" do
      is_expected.to eq ::Arel.sql('NOW()')
    end

    it "should be aliased as `sql`" do
      expect(described_class.instance_method(:sql)).to eq described_class.instance_method(:sql_literal)
    end

    it { is_expected.to be_extended_by SexyScopes::Arel::ExpressionMethods }

    it { is_expected.to be_extended_by SexyScopes::Arel::PredicateMethods }
  end
end

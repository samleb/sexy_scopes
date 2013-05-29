require 'spec_helper'

describe SexyScopes::ActiveRecord::ClassMethods do
  it "should extend ActiveRecord::Base" do
    ActiveRecord::Base.should be_extended_by SexyScopes::ActiveRecord::ClassMethods
  end
  
  describe ".attribute(name)" do
    subject { User.attribute(:username) }
    
    it "should return an Arel attribute for the given name" do
      subject.should == User.arel_table[:username]
    end
    
    it { should be_extended_by SexyScopes::ExpressionWrappers }
  end
  
  describe ".sql_literal(expression)" do
    subject { User.sql_literal('NOW()') }
    
    it "should return an Arel literal for given expression" do
      subject.should == ::Arel.sql('NOW()')
    end
    
    it "should be aliased as `sql`" do
      SexyScopes::ActiveRecord::ClassMethods.instance_method(:sql).should ==
        SexyScopes::ActiveRecord::ClassMethods.instance_method(:sql_literal)
    end
    
    it { should be_extended_by SexyScopes::ExpressionWrappers }
    
    it { should be_extended_by SexyScopes::PredicateWrappers }
  end
end

describe SexyScopes::ActiveRecord::DynamicMethods do
  before do
    ActiveRecord::Migration.create_table :temp_users
    ActiveRecord::Migration.add_column :temp_users, :username, :string
    class ::TempUser < ActiveRecord::Base; end
  end
  
  after do
    Object.send(:remove_const, :TempUser)
    ActiveRecord::Migration.drop_table :temp_users
  end
  
  it "should delegate to `attribute` when the method name is the name of an existing column" do
    TempUser.should respond_to(:username)
    TempUser.should_receive(:attribute).with(:username).once.and_return(:ok)
    TempUser.username.should == :ok
  end
  
  it "should define an attribute method to avoid repeated `method_missing` calls" do
    TempUser.username
    TempUser.should_not_receive(:method_missing)
    TempUser.username
  end
  
  it "should return a Method object for an existing column" do
    expect { TempUser.method(:username) }.to_not raise_error
  end
  
  it "should raise NoMethodError for a non-existing column" do
    TempUser.should_not respond_to(:foobar)
    expect { TempUser.foobar }.to raise_error NoMethodError
  end
  
  it "should not raise error when table doesn't exist" do
    TempUser.table_name = "inexistent_users"
    expect { TempUser.respond_to?(:username) }.to_not raise_error
  end
end

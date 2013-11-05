require 'spec_helper'

describe SexyScopes::ActiveRecord::DynamicMethods do
  before do
    ActiveRecord::Migration.create_table :temp_users do |t|
      t.string :username
      t.string :name
      t.string :foo
      t.integer :score
    end
    
    class ::TempUser < ActiveRecord::Base
      # Deliberately defining a method whose name is a column
      # This shouldn't be overwriten by the system
      def self.foo
        :bar
      end
    end
  end
  
  after do
    Object.send(:remove_const, :TempUser)
    ActiveRecord::Migration.drop_table :temp_users
  end
  
  it "should delegate to `attribute` when the method name is the name of an existing column" do
    TempUser.should_receive(:attribute).with('username').once.and_return(:ok)
    TempUser.username.should == :ok
  end
  
  it "should define attribute methods all at once, avoiding repeated `method_missing` calls" do
    TempUser.username
    TempUser.should_not_receive(:method_missing)
    TempUser.username
    TempUser.score
  end
  
  it "should not override existing methods" do
    TempUser.foo.should == :bar
    TempUser.name.should == "TempUser"
  end
  
  it "should respond to methods whose names are column names" do
    TempUser.should respond_to(:username)
  end
  
  it "should return a Method object for methods whose names are column names" do
    expect { TempUser.method(:username) }.to_not raise_error
  end
  
  it "should raise `NoMethodError` for methods whose names aren't column names" do
    TempUser.should_not respond_to(:foobar)
    expect { TempUser.foobar }.to raise_error NoMethodError
  end
  
  it "should not raise error when table doesn't exist" do
    TempUser.table_name = "inexistent_users"
    expect { TempUser.username }.to raise_error NoMethodError
  end
  
  shared_examples "a non-table class" do
    it "should not raise error when calling `respond_to?`" do
      expect { subject.respond_to?(:username) }.not_to raise_error
    end
    
    it "should raise `NoMethodError` error when going through `method_missing`" do
      expect { subject.username }.to raise_error NoMethodError
    end
  end
  
  context "when the table doesn't exist" do
    before { TempUser.table_name = "inexistent_users" }
    subject { TempUser }
    it_behaves_like "a non-table class"
  end
  
  context "when the class is an abstract class" do
    before { TempUser.abstract_class = true }
    subject { TempUser }
    it_behaves_like "a non-table class"
  end
  
  context "when the class is `ActiveRecord::Base`" do
    subject { ActiveRecord::Base }
    it_behaves_like "a non-table class"
  end
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SexyScopes do
  it "extends `ActiveRecord::Base` with `SexyScopes::ClassMethods`" do
    ActiveRecord::Base.singleton_class.included_modules.should include(SexyScopes::ClassMethods)
  end
  
  describe "the `attribute` class method" do
    before do
      @attribute = User.attribute(:username)
    end
    
    it "returns a `SexyScopes::Attribute` instance for the given attribute" do
      @attribute.should be_a(SexyScopes::Attribute)
      @attribute.name.should == :username
    end
  end
  
  describe SexyScopes::Attribute do
    before do
      @attribute = User.attribute(:username)
      @arel_attribute = User.arel_table[:username]
    end
    
    AREL_ALIASES = {
      :<  => :lt,
      :<= => :lteq,
      :== => :eq,
      :>= => :gteq,
      :>  => :gt,
      :=~ => :matches
    }
    
    AREL_ALIASES.each do |method, arel_method|
      it "aliases `Arel::Attribute##{arel_method}` with operator `#{method}`" do
        @attribute.send(method, :any_value).should == @arel_attribute.send(arel_method, :any_value)
      end
    end
    
    (AREL_ALIASES.values + ['in']).each do |arel_method|
      it "behaves like an `Arel::Attribute` when sent `#{arel_method}`" do
        @attribute.send(arel_method, :any_value).should == @arel_attribute.send(arel_method, :any_value)
      end
    end
  end
end

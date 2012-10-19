require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SexyScopes do
  AREL_ALIASES = {
    :<  => :lt,
    :<= => :lteq,
    :== => :eq,
    :>= => :gteq,
    :>  => :gt,
    :=~ => :matches
  }
  
  it "extends `ActiveRecord::Base` with `SexyScopes::ClassMethods`" do
    ActiveRecord::Base.singleton_class.included_modules.should include(SexyScopes::ActiveRecord::ClassMethods)
  end
  
  describe "the `attribute` class method" do
    it "returns a `SexyScopes::Attribute` instance for the given attribute" do
      @attribute = User.attribute(:username)
      @attribute.should be_a(SexyScopes::ActiveRecord::Attribute)
      @attribute.name.should == :username
    end
  end
  
  describe SexyScopes::ActiveRecord::Attribute do
    before do
      @attribute = User.attribute(:username)
      @arel_attribute = User.arel_table[:username]
    end
    
    it "delegates messages to the equivalent `Arel::Attribute`" do
      # FIXME: shouldn't mess with such an implementation detail
      @attribute.__getobj__.should == @arel_attribute
    end
    
    AREL_ALIASES.each do |method, arel_method|
      it "aliases `Arel::Attribute##{arel_method}` with operator `#{method}`" do
        @attribute.send(method, :foo).should == @arel_attribute.send(arel_method, :foo)
      end
    end
  end
  
  describe "the `literal` class method" do
    it "returns a `SexyScopes::SqlLiteral` instance for the given expression" do
      @literal = User.literal('NOW()')
      @literal.should be_a(SexyScopes::ActiveRecord::SqlLiteral)
      @literal.to_s.should == 'NOW()'
    end
  end
  
  describe SexyScopes::ActiveRecord::SqlLiteral do
    before do
      @literal = User.literal('NOW()')
      @arel_literal = Arel.sql('NOW()')
    end
    
    it "delegates messages to the equivalent `Arel::SqlLiteral`" do
      # FIXME: shouldn't mess with such an implementation detail
      @literal.__getobj__.should == @arel_literal
    end
    
    AREL_ALIASES.each do |method, arel_method|
      it "aliases `Arel::SqlLiteral##{arel_method}` with operator `#{method}`" do
        @literal.send(method, :foo).should == @arel_literal.send(arel_method, :foo)
      end
    end
  end
end

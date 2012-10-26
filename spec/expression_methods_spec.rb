require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

shared_examples "an expression method" do
  it "should return an Arel node" do
    @expression.class.name.should =~ /^Arel::/
  end
  
  it "should extend the result with ExpressionWrappers" do
    @expression.should be_extended_by(SexyScopes::Arel::ExpressionWrappers)
  end
end

describe SexyScopes::Arel::ExpressionMethods do
  before do
    @attribute = User.attribute(:score)
  end
  
  describe "when sent `*`" do
    it_behaves_like "an expression method"
    
    before do
      @expression = @attribute * 42.0
    end
    
    it "should generate the correct SQL" do
      @expression.should generate_sql(%{"users"."score" * 42.0})
    end
  end
  
  describe "when sent `+`" do
    it_behaves_like "an expression method"
    
    before do
      @expression = @attribute + 42.0
    end
    
    it "should generate the correct SQL" do
      @expression.should generate_sql(%{("users"."score" + 42.0)})
    end
  end
  
  describe "when sent `-`" do
    it_behaves_like "an expression method"
    
    before do
      @expression = @attribute - 42.0
    end
    
    it "should generate the correct SQL" do
      @expression.should generate_sql(%{("users"."score" - 42.0)})
    end
  end
  
  describe "when sent `/`" do
    it_behaves_like "an expression method"
    
    before do
      @expression = @attribute / 42.0
    end
    
    it "should generate the correct SQL" do
      @expression.should generate_sql(%{"users"."score" / 42.0})
    end
  end
end

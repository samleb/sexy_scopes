require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

shared_examples "an expression method" do
  it "should return an Arel node" do
    subject.class.name.should =~ /^Arel::/
  end
  
  it { should be_extended_by SexyScopes::ExpressionWrappers }
end

describe SexyScopes::Arel::MathMethods do
  before do
    @attribute = User.attribute(:score)
  end
  
  describe "the method `*`" do
    subject { @attribute * 42.0 }
    
    it_behaves_like "an expression method"
    
    it { should convert_to_sql %{"users"."score" * 42.0} }
  end
  
  describe "the method `+`" do
    subject { @attribute + 42.0 }
    
    it_behaves_like "an expression method"
    
    it { should convert_to_sql %{("users"."score" + 42.0)} }
  end
  
  describe "the method `-`" do
    subject { @attribute - 42.0 }
    
    it_behaves_like "an expression method"
    
    it { should convert_to_sql %{("users"."score" - 42.0)} }
  end
  
  describe "the method `/`" do
    subject { @attribute / 42.0 }
    
    it_behaves_like "an expression method"
    
    it { should convert_to_sql %{"users"."score" / 42.0} }
  end
  
  describe "type coercion" do
    subject { 42.0 / @attribute }
    
    it_behaves_like "an expression method"
    
    it { should convert_to_sql %{42.0 / "users"."score"} }
  end
end

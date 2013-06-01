require 'spec_helper'

describe SexyScopes::Arel::Math do
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

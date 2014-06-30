require 'spec_helper'

describe SexyScopes::Arel::Math do
  before do
    @attribute = User.attribute(:score)
  end
  
  describe "the method `*`" do
    subject { @attribute * 42 }
    
    it_behaves_like "an expression method"
    
    it { should convert_to_sql %{"users"."score" * 42} }
  end
  
  describe "the method `+`" do
    subject { @attribute + 42 }
    
    it_behaves_like "an expression method"
    
    it { should convert_to_sql %{("users"."score" + 42)} }
  end
  
  describe "the method `-`" do
    subject { @attribute - 42 }
    
    it_behaves_like "an expression method"
    
    it { should convert_to_sql %{("users"."score" - 42)} }
  end
  
  describe "the method `/`" do
    subject { @attribute / 42 }
    
    it_behaves_like "an expression method"
    
    it { should convert_to_sql %{"users"."score" / 42} }
  end
  
  describe "Ruby type coercion" do
    subject { 42 / @attribute }
    
    it_behaves_like "an expression method"
    
    it { should convert_to_sql %{42 / "users"."score"} }
  end
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SexyScopes::Arel::BooleanMethods do
  before do
    @attribute = User.attribute(:score)
    @predicate = @attribute < 1000
    @predicate2 = @attribute >= 200
  end
  
  describe ".not" do
    subject { @predicate.not }
    
    it_behaves_like "a predicate method"
    
    it { should convert_to_sql %{NOT ("users"."score" < 1000)} }
  end
  
  describe ".and(predicate)" do
    subject { @predicate.and(@predicate2) }
    
    it_behaves_like "a predicate method"
    
    it { should convert_to_sql %{"users"."score" < 1000 AND "users"."score" >= 200} }
  end
  
  describe ".or(predicate)" do
    subject { @predicate.or(@predicate2) }
    
    it_behaves_like "a predicate method"
    
    it { should convert_to_sql %{("users"."score" < 1000 OR "users"."score" >= 200)} }
  end
end

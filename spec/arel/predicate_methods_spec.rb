require 'spec_helper'

describe SexyScopes::Arel::PredicateMethods do
  before do
    @attribute = User.attribute(:score)
    @predicate = @attribute < 1000
    @predicate2 = @attribute >= 200
  end
  
  describe ".not" do
    subject { @predicate.not }
    
    it_behaves_like "a predicate method"
    
    it { should convert_to_sql %{NOT ("users"."score" < 1000)} }
    
    it "should be aliased as `~`" do
      @predicate.method(:~).should == @predicate.method(:not)
    end
  end
  
  describe ".and(predicate)" do
    subject { @predicate.and(@predicate2) }
    
    it_behaves_like "a predicate method"
    
    it { should convert_to_sql %{"users"."score" < 1000 AND "users"."score" >= 200} }
    
    it "should be aliased as `&`" do
      @predicate.method(:&).should == @predicate.method(:and)
    end
  end
  
  describe ".or(predicate)" do
    subject { @predicate.or(@predicate2) }
    
    it_behaves_like "a predicate method"
    
    it { should convert_to_sql %{("users"."score" < 1000 OR "users"."score" >= 200)} }
    
    it "should be aliased as `|`" do
      @predicate.method(:|).should == @predicate.method(:or)
    end
  end
end

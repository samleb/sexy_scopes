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

    it { is_expected.to convert_to_sql %{NOT ("users"."score" < 1000)} }

    it "should be aliased as `~`" do
      expect(@predicate.method(:~)).to eq @predicate.method(:not)
    end
  end

  describe ".and(predicate)" do
    subject { @predicate.and(@predicate2) }

    it_behaves_like "a predicate method"

    it { is_expected.to convert_to_sql %{"users"."score" < 1000 AND "users"."score" >= 200} }

    it "should be aliased as `&`" do
      expect(@predicate.method(:&)).to eq @predicate.method(:and)
    end
  end

  describe ".or(predicate)" do
    subject { @predicate.or(@predicate2) }

    it_behaves_like "a predicate method"

    it { is_expected.to convert_to_sql %{("users"."score" < 1000 OR "users"."score" >= 200)} }

    it { is_expected.to be_extended_by Arel::Predications }

    it "should be aliased as `|`" do
      expect(@predicate.method(:|)).to eq @predicate.method(:or)
    end
  end
end

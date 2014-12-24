RSpec.shared_examples "a predicate method" do
  it "should return an Arel node" do
    expect(subject.class.name).to match /^(SexyScopes::)?Arel::Nodes::/
  end

  it { is_expected.to be_extended_by SexyScopes::Arel::PredicateMethods }
end

RSpec.shared_examples "an expression method" do
  it "should return an Arel node" do
    expect(subject.class.name).to match /^(SexyScopes::)?Arel::Nodes::/
  end

  it { is_expected.to be_extended_by SexyScopes::Arel::ExpressionMethods }
end

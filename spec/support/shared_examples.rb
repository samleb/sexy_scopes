RSpec.shared_examples "a predicate method" do
  it "should return an Arel node" do
    subject.class.name.should =~ /^(SexyScopes::)?Arel::Nodes::/
  end

  it { should be_extended_by SexyScopes::Arel::PredicateMethods }
end

RSpec.shared_examples "an expression method" do
  it "should return an Arel node" do
    subject.class.name.should =~ /^(SexyScopes::)?Arel::Nodes::/
  end

  it { should be_extended_by SexyScopes::Arel::ExpressionMethods }
end

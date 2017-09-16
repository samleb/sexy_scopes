require 'spec_helper'

describe SexyScopes::Arel::Predications do
  before do
    @attribute = User.attribute(:score)
  end

  METHODS = {
    # Arel method   => [ Ruby operator, SQL operator ]
    :eq             => [ '==',  '= %s'        ],
    :in             => [ nil,   'IN (%s)'     ],
    :matches        => [ '=~',  'LIKE %s'     ],
    :does_not_match => [ '!~',  'NOT LIKE %s' ],
    :gteq           =>   '>=',
    :gt             =>   '>',
    :lt             =>   '<',
    :lteq           =>   '<=',
    :not_eq         =>   '!='
  }

  METHODS.each do |method, (operator, sql_operator)|
    sql_operator ||= "#{operator} %s"

    describe "the method `#{method}`" do
      subject { @attribute.send(method, 42) }

      it_behaves_like "a predicate method"

      it { is_expected.to convert_to_sql %{"users"."score" #{sql_operator % 42}} }

      if operator
        it "is aliased as `#{operator}`" do
          expect(described_class.instance_method(operator)).to eq described_class.instance_method(method)
        end
      end
    end
  end

  context "LIKE operator" do
    before do
      @attribute = User.attribute(:username)
    end

    describe "the method `matches`" do
      subject { @attribute.matches('bob') }

      it_behaves_like "a predicate method"

      it { is_expected.to convert_to_sql %{"users"."username" LIKE 'bob'} }
    end

    describe "the method `does_not_match`" do
      subject { @attribute.does_not_match('bob') }

      it_behaves_like "a predicate method"

      it { is_expected.to convert_to_sql %{"users"."username" NOT LIKE 'bob'} }
    end
  end

  context "Regular Expressions" do
    before do
      @attribute = User.attribute(:username)
    end

    describe "the method `matches_regexp`" do
      subject { @attribute.matches_regexp(/foo/) }

      it_behaves_like "a predicate method"

      it { is_expected.to be_a SexyScopes::Arel::Nodes::RegexpMatches }
    end

    describe "the method `does_not_match_regexp`" do
      subject { @attribute.does_not_match_regexp(/foo/) }

      it_behaves_like "a predicate method"

      it { is_expected.to be_a Arel::Nodes::Not }

      it "should be the negation of an SexyScopes::Arel::Nodes::RegexpMatches" do
        expect(subject.expr).to be_a SexyScopes::Arel::Nodes::RegexpMatches
      end
    end

    describe "the operator `=~` called with a Regexp" do
      it "should delegate to the method `matches_regexp`" do
        expect(@attribute).to receive(:matches_regexp).once.with(/foo/).and_return(:ok)
        expect(@attribute =~ /foo/).to eq :ok
      end
    end

    describe "the operator `!~` called with a Regexp" do
      it "should delegate to the method `matches_regexp`" do
        expect(@attribute).to receive(:does_not_match_regexp).once.with(/foo/).and_return(:ok)
        expect(@attribute !~ /foo/).to eq :ok
      end
    end
  end
end

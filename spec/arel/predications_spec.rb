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

      it { should convert_to_sql %{"users"."score" #{sql_operator % 42}} }

      if operator
        it "is aliased as `#{operator}`" do
          described_class.instance_method(operator).should == described_class.instance_method(method)
        end
      end
    end
  end

  if SexyScopes.arel_6?
    context "LIKE function with ESCAPE clause" do
      before do
        @attribute = User.attribute(:username)
      end

      describe "the method `matches`, called with the `escape` argument" do
        subject { @attribute.matches('bob', '|') }

        it_behaves_like "a predicate method"

        it { should convert_to_sql %{"users"."username" LIKE 'bob' ESCAPE '|'} }
      end

      describe "the method `does_not_match`, called with the `escape` argument" do
        subject { @attribute.does_not_match('bob', '|') }

        it_behaves_like "a predicate method"

        it { should convert_to_sql %{"users"."username" NOT LIKE 'bob' ESCAPE '|'} }
      end
    end
  end

  context "(Regular Expressions)" do
    before do
      @attribute = User.attribute(:username)
    end

    describe "the method `matches_regexp`" do
      subject { @attribute.matches_regexp(/foo/) }

      it_behaves_like "a predicate method"

      it { should be_a SexyScopes::Arel::Nodes::RegexpMatches }
    end

    describe "the method `does_not_match_regexp`" do
      subject { @attribute.does_not_match_regexp(/foo/) }

      it_behaves_like "a predicate method"

      it { should be_a Arel::Nodes::Not }

      it "should be the negation of an SexyScopes::Arel::Nodes::RegexpMatches" do
        subject.expr.should be_a SexyScopes::Arel::Nodes::RegexpMatches
      end
    end

    describe "the operator `=~` called with a Regexp" do
      it "should delegate to the method `matches_regexp`" do
        @attribute.should_receive(:matches_regexp).once.with(/foo/).and_return(:ok)
        (@attribute =~ /foo/).should eq :ok
      end
    end

    describe "the operator `!~` called with a Regexp" do
      it "should delegate to the method `matches_regexp`" do
        @attribute.should_receive(:does_not_match_regexp).once.with(/foo/).and_return(:ok)
        (@attribute !~ /foo/).should eq :ok
      end
    end
  end
end

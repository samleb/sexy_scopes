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
      subject { @attribute.send(method, 42.0) }
      
      it_behaves_like "a predicate method"
      
      it { should convert_to_sql %{"users"."score" #{sql_operator % 42.0}} }
      
      if operator
        it "is aliased as `#{operator}`" do
          described_class.instance_method(operator).should == described_class.instance_method(method)
        end
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
      
      # FIXME: this belongs to a nodes/regexp_matches_spec.rb with RDBMS-specific specs
      it { should convert_to_sql %{"users"."username" REGEXP 'foo'} }
    end
    
    describe "the method `does_not_match_regexp`" do
      subject { @attribute.does_not_match_regexp(/foo/) }
      
      it_behaves_like "a predicate method"
      
      it { should be_a Arel::Nodes::Not }
      
      it "should be the negation of an SexyScopes::Arel::Nodes::RegexpMatches" do
        subject.expr.should be_a SexyScopes::Arel::Nodes::RegexpMatches
      end
      
      # FIXME: this belongs to a nodes/regexp_matches_spec.rb with RDBMS-specific specs
      it { should convert_to_sql %{NOT ("users"."username" REGEXP 'foo')} }
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

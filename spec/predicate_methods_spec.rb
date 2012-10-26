require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

shared_examples "a predicate method" do
  it "should return an Arel node" do
    @predicate.class.name.should =~ /^Arel::/
  end
  
  it "should extend the result with PredicateWrappers" do
    @predicate.should be_extended_by(SexyScopes::Arel::PredicateWrappers)
  end
end

describe SexyScopes::Arel::PredicateMethods do
  before do
    @attribute = User.attribute(:score)
  end
  
  METHODS = {
    :eq             => ['==', '= %s'       ],
    :in             => [nil,  'IN (%s)'    ],
    :matches        => ['=~', 'LIKE %s'    ],
    :does_not_match => ['!~', 'NOT LIKE %s'],
    :gteq           => '>=',
    :gt             => '>',
    :lt             => '<',
    :lteq           => '<=',
    :not_eq         => '!='
  }
  
  METHODS.each do |original, (operator, sql_operator)|
    sql_operator ||= "#{operator} %s"
    
    describe "the method ##{original}" do
      it_behaves_like "a predicate method"
      
      before do
        @predicate = @attribute.send(original, 42.0)
      end
      
      it "should generate the correct SQL" do
        @predicate.should generate_sql(%{"users"."score" } + sql_operator % 42.0)
      end
      
      it "is aliased as `#{operator}`" do
        @attribute.method(operator).should == @attribute.method(original)
      end if operator
    end
  end
end

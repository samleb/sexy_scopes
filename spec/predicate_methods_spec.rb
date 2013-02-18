require 'spec_helper'

describe SexyScopes::Arel::PredicateMethods do
  before do
    @attribute = User.attribute(:score)
  end
  
  RUBY_19_METHODS = %w( != !~ )
  
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
      
      if operator && (!RUBY_19_METHODS.include?(operator) || ruby_19?)
        it "is aliased as `#{operator}`" do
          SexyScopes::Arel::PredicateMethods.instance_method(operator).should ==
            SexyScopes::Arel::PredicateMethods.instance_method(method)
        end
      end
    end
  end
end

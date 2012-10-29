require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SexyScopes::ActiveRecord do
  it "should extend ActiveRecord::Base" do
    ActiveRecord::Base.should be_extended_by SexyScopes::ActiveRecord
  end
  
  describe ".attribute(name)" do
    subject { User.attribute(:username) }
    
    it "should return an Arel attribute for the given name" do
      subject.should eql User.arel_table[:username]
    end
    
    it { should be_extended_by SexyScopes::Arel::ExpressionWrappers }
  end
  
  describe ".sql_literal(expression)" do
    subject { User.sql_literal('NOW()') }
    
    it "should return an Arel literal for given expression" do
      subject.should eql(::Arel.sql('NOW()'))
    end
    
    it "should be aliased as `sql`" do
      SexyScopes::ActiveRecord.instance_method(:sql).should ==
        SexyScopes::ActiveRecord.instance_method(:sql_literal)
    end
    
    it { should be_extended_by SexyScopes::Arel::ExpressionWrappers }
    
    it { should be_extended_by SexyScopes::Arel::PredicateWrappers }
  end
  
  protected
    def arel_class(namespace, name)
      Arel.const_get(namespace).const_get(name)
    rescue NameError
      Arel.const_get(name)
    end
end

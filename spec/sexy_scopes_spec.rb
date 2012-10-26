require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SexyScopes::ActiveRecord do
  it "extends ActiveRecord::Base with ClassMethods" do
    ActiveRecord::Base.should be_extended_by(SexyScopes::ActiveRecord::ClassMethods)
  end
  
  describe "ClassMethods" do
    describe ".attribute(name)" do
      subject { User.attribute(:username) }
      
      it "should return an Arel attribute for the given name" do
        subject.should eql(User.arel_table[:username])
      end
      
      it { should be_extended_by(SexyScopes::Arel::ExpressionWrappers) }
    end
    
    describe ".literal(expression)" do
      subject { User.literal('NOW()') }
      
      it "should return an Arel literal for given expression" do
        subject.should eql(::Arel.sql('NOW()'))
      end
      
      it { should be_extended_by(SexyScopes::Arel::ExpressionWrappers) }
      
      it { should be_extended_by(SexyScopes::Arel::PredicateWrappers) }
    end
  end
  
  protected
    def arel_class(namespace, name)
      Arel.const_get(namespace).const_get(name)
    rescue NameError
      Arel.const_get(name)
    end

end

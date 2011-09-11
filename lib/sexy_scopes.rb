require 'delegate'
require 'active_record'

module SexyScopes
  AREL_ALIASES = {
    :<  => :lt,
    :<= => :lteq,
    :== => :eq,
    :>= => :gteq,
    :>  => :gt,
    :=~ => :matches
  }
  
  module ClassMethods
    def attribute(name)
      Attribute.new(arel_table[name])
    end
    
    def literal(expression)
      SqlLiteral.new(Arel.sql(expression))
    end
  end
  
  %w( Attribute SqlLiteral ).each do |class_name|
    class_eval <<-EVAL
      class #{class_name} < DelegateClass(Arel::#{class_name})
        AREL_ALIASES.each do |aliased, original|
          alias_method aliased, original
        end
      end
    EVAL
  end
  
  ActiveRecord::Base.extend ClassMethods
end

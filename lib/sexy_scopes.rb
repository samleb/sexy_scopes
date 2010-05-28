require 'delegate'
require 'active_record'
require 'arel'

module SexyScopes
  module ClassMethods
    def attribute(name)
      Attribute.new(arel_table[name])
    end
  end
  
  class Attribute < DelegateClass(Arel::Attribute)
    alias_method :<,  :lt
    alias_method :<=, :lteq
    alias_method :==, :eq
    alias_method :>=, :gteq
    alias_method :>,  :gt
    alias_method :=~, :matches
  end
  
  ActiveRecord::Base.extend ClassMethods
end

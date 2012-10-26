require 'delegate'
require 'active_record'
require 'sexy_scopes/wrappers'
require 'sexy_scopes/arel'

module SexyScopes
  module ActiveRecord
    module ClassMethods
      include Wrappers
      
      # Creates an `Attribute` instance for the given <tt>name</tt>.
      # @return [Attribute] the instance for the given attribute `name`
      def attribute(name)
        extend_expression(arel_table[name])
      end

      # Creates an `SqlLiteral` instance for the given `expression`.
      def literal(expression)
        extend_predicate(extend_expression(::Arel.sql(expression)))
      end
    end

    ::ActiveRecord::Base.extend ClassMethods

  end
end

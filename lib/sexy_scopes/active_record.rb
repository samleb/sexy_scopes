require 'delegate'
require 'active_record'
require 'sexy_scopes/wrappers'
require 'sexy_scopes/arel'

module SexyScopes
  module ActiveRecord
    include Wrappers

    # Creates and extends an Arel <tt>Attribute</tt> representing the table's column with
    # the given <tt>name</tt>.
    #
    # @note Please note that no exception will be raised if no such column actually exists.
    def attribute(name)
      attribute = arel_table[name]
      extend_expression(attribute)
    end

    # Creates and extends an Arel <tt>SqlLiteral</tt> instance for the given <tt>expression</tt>,
    # first converted to a string using <tt>to_s</tt>
    #
    # == Example
    #   def Circle.with_perimeter_smaller_than(perimeter)
    #     where sql_literal(2 * Math::PI) * radius < perimeter
    #   end
    #   Circle.with_perimeter_smaller_than(20)
    #   # SELECT "circles".* FROM "circles" WHERE (6.283185307179586 * "circles"."radius" < 20)
    #
    def sql_literal(expression)
      ::Arel.sql(expression.to_s).tap do |literal|
        extend_expression(literal)
        extend_predicate(literal)
      end
    end
    alias_method :sql, :sql_literal
  end
  
  # Add these methods to Active Record
  ::ActiveRecord::Base.extend SexyScopes::ActiveRecord
end

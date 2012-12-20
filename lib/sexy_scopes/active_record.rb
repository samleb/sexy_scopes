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
    # @param [String, Symbol] name The attribute name
    #
    # @note Please note that no exception is raised if no such column actually exists.
    #
    # @example
    #   User.where(User.attribute(:score) > 1000)
    #   # => SELECT "users".* FROM "users" WHERE ("users"."score" > 1000)
    #
    def attribute(name)
      attribute = arel_table[name]
      extend_expression(attribute)
    end

    # Creates and extends an Arel <tt>SqlLiteral</tt> instance for the given <tt>expression</tt>,
    # first converted to a string using <tt>to_s</tt>.
    #
    # @param [String, #to_s] expression Any SQL expression.
    #
    # @example
    #   def Circle.with_perimeter_smaller_than(perimeter)
    #     where sql(2 * Math::PI) * radius < perimeter
    #   end
    #   
    #   Circle.with_perimeter_smaller_than(20)
    #   # => SELECT "circles".* FROM "circles" WHERE (6.283185307179586 * "circles"."radius" < 20)
    #
    def sql_literal(expression)
      ::Arel.sql(expression.to_s).tap do |literal|
        extend_expression(literal)
        extend_predicate(literal)
      end
    end
    alias_method :sql, :sql_literal
    
    # @!visibility private
    def respond_to?(method_name, include_private = false) # :nodoc:
      super || respond_to_missing?(method_name, include_private)
    end
    
    # # @!visibility private
    def respond_to_missing?(method_name, include_private = false) # :nodoc:
      Object.respond_to?(:respond_to_missing?) && super || attribute_names.include?(method_name.to_s)
    end
    
    private
      # Equivalent to calling {#attribute} with the missing method's <tt>name</tt> if the table
      # has a column with that name.
      #
      # Delegates to superclass implementation otherwise, eventually raising <tt>NoMethodError</tt>.
      # 
      # @see #attribute
      #
      # @note Due to the way this works, be careful not to use this syntactic sugar with existing
      #       <tt>ActiveRecord::Base</tt> methods (see last example).
      #
      # @raise [NoMethodError] if the table has no corresponding column
      #
      # @example
      #   # Suppose the "users" table has an "email" column, then these are equivalent:
      #   User.email
      #   User.attribute(:email)
      #   
      # @example
      #   # Here is the previous example (from `attribute`) rewritten:
      #   User.where(User.score > 1000)
      #   # => SELECT "users".* FROM "users" WHERE ("users"."score" > 1000)
      #
      # @example
      #   # Don't use it with existing `ActiveRecord::Base` methods, i.e. `name`:
      #   User.name # => "User"
      #   # In these cases you'll have to use `attribute` explicitely
      #   User.attribute(:name)
      #
      def method_missing(name, *args)
        if column_names.include?(name.to_s)
          define_sexy_scopes_attribute_method(name)
          attribute(name)
        else
          super
        end
      end
      
      def define_sexy_scopes_attribute_method(name)
        class_eval <<-EVAL, __FILE__, __LINE__ + 1
          def self.#{name}        # def self.username
            attribute(:#{name})   #   attribute(:username)
          end                     # end
        EVAL
      end
  end
  
  # Add these methods to Active Record
  ::ActiveRecord::AttributeMethods::ClassMethods.extend SexyScopes::ActiveRecord
end

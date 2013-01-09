module SexyScopes
  module ActiveRecord
    module DynamicMethods
      # @!visibility private
      def respond_to?(method_name, include_private = false) # :nodoc:
        super || respond_to_missing?(method_name, include_private)
      end

      # # @!visibility private
      def respond_to_missing?(method_name, include_private = false) # :nodoc:
        Object.respond_to?(:respond_to_missing?) && super || sexy_scopes_has_attribute?(method_name)
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
          if sexy_scopes_has_attribute?(name)
            sexy_scopes_define_attribute_method(name)
            attribute(name)
          else
            super
          end
        end

        def sexy_scopes_define_attribute_method(name)
          class_eval <<-EVAL, __FILE__, __LINE__ + 1
            def self.#{name}        # def self.username
              attribute(:#{name})   #   attribute(:username)
            end                     # end
          EVAL
        end

        def sexy_scopes_has_attribute?(attribute_name)
          if self != ::ActiveRecord::Base && !abstract_class? && table_exists?
            column_names.include?(attribute_name.to_s)
          end
        rescue ::ActiveRecord::StatementInvalid
          false
        end
    end
  end
end

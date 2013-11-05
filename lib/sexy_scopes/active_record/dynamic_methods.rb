module SexyScopes
  module ActiveRecord
    module DynamicMethods
      private
        def respond_to_missing?(method_name, *)
          # super currently resolve to Object#respond_to_missing? which return false,
          # but future version of ActiveRecord::Base might implement respond_to_missing?
          if @sexy_scopes_attribute_methods_generated
            super
          else
            sexy_scopes_has_attribute?(method_name)
          end
        end
        
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
        def method_missing(name, *args, &block)
          if @sexy_scopes_attribute_methods_generated
            super
          else
            sexy_scopes_define_attribute_methods
            send(name, *args, &block)
          end
        end
        
        def sexy_scopes_define_attribute_methods
          @sexy_scopes_attribute_methods_generated = true
          return unless sexy_scopes_is_table?
          column_names.each do |name|
            define_singleton_method(name) { attribute(name) }
          end
        end
        
        def sexy_scopes_has_attribute?(attribute_name)
          sexy_scopes_is_table? && column_names.include?(attribute_name.to_s)
        end
        
        def sexy_scopes_is_table?
          !(equal?(::ActiveRecord::Base) || abstract_class?) && table_exists?
        end
    end
  end
end

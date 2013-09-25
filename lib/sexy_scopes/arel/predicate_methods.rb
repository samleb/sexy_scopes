module SexyScopes
  module Arel
    module PredicateMethods
      # <tt>Arel::Grouping</tt> nodes didn't include <tt>Arel::Predications</tt> before Arel 3, but <tt>or</tt> 
      # returns an <tt>Arel::Grouping</tt> node (surrounds the SQL <tt>OR</tt> clause with parenthesis).
      # Since ActiveRecord 3.1 depends on Arel 2, including the module here ensures the methods will exist.
      include ::Arel::Predications
      
      def not
        SexyScopes.extend_predicate(super)
      end
      alias ~ not
      
      def or(other)
        SexyScopes.extend_predicate(super)
      end
      alias | or
      
      def and(other)
        SexyScopes.extend_predicate(super)
      end
      alias & and
    end
  end
end

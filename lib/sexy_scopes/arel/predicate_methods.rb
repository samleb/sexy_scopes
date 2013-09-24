module SexyScopes
  module Arel
    module PredicateMethods
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

module SexyScopes
  module Arel
    module BooleanMethods
      def not
        extend_predicate(super)
      end
      alias ~ not
      
      def or(other)
        extend_predicate(super)
      end
      alias | or
      
      def and(other)
        extend_predicate(super)
      end
      alias & and
    end
  end
end

module SexyScopes
  # @!visibility private
  module Wrappers # :nodoc:
    private
      def extend_expression(expression)
        expression.extend(ExpressionWrappers)
      end
      
      def extend_predicate(predicate)
        predicate.extend(PredicateWrappers)
      end
  end
end

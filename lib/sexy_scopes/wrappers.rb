module SexyScopes
  # @!visibility private
  module Wrappers
    private
      def extend_expression(expression)
        expression.extend(Arel::ExpressionWrappers)
      end
      
      def extend_predicate(predicate)
        predicate.extend(Arel::PredicateWrappers)
      end
  end
end

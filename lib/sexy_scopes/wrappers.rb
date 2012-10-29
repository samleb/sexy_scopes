module SexyScopes
  # @!visibility private
  module Wrappers # :nodoc:
    private
      def extend_expression(expression)
        expression.extend(Arel::ExpressionWrappers)
      end
      
      def extend_predicate(predicate)
        predicate.extend(Arel::PredicateWrappers)
      end
  end
end

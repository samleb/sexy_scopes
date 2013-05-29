module SexyScopes
  # @!visibility private
  module Wrappers # :nodoc:
    private
      def extend_expression(expression)
        expression.extend(Arel::ExpressionMethods)
      end
      
      def extend_predicate(predicate)
        predicate.extend(Arel::PredicateMethods)
      end
  end
end

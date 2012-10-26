module SexyScopes
  module Arel
    # @!visibility private
    module ExpressionMethods
      def *(other)
        extend_expression(super)
      end
      
      def +(other)
        extend_expression(super)
      end
      
      def -(other)
        extend_expression(super)
      end
      
      def /(other)
        extend_expression(super)
      end
    end
  end
end

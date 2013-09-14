module SexyScopes
  module Arel
    module Math
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
      
      def coerce(other)
        expression = ::Arel.sql(other.to_s)
        [extend_expression(expression), self]
      end
    end
  end
end

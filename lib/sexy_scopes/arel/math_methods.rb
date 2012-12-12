module SexyScopes
  module Arel
    module MathMethods
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
        [extend_expression(::Arel.sql(other.to_s)), self]
      end
    end
  end
end

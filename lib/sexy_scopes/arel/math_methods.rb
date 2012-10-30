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
    end
  end
end

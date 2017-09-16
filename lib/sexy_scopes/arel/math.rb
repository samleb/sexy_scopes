module SexyScopes
  module Arel
    module Math
      include Typecasting

      def *(other)
        SexyScopes.extend_expression(super)
      end

      def +(other)
        SexyScopes.extend_expression(super)
      end

      def -(other)
        SexyScopes.extend_expression(super)
      end

      def /(other)
        SexyScopes.extend_expression(super)
      end

      def coerce(other)
        expression = ::Arel.sql(other.to_s)
        [SexyScopes.extend_expression(expression), self]
      end
    end
  end
end

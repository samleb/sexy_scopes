module SexyScopes
  module Arel
    module Typecasting
      def *(other)
        super SexyScopes.type_cast(other, self)
      end

      def +(other)
        super SexyScopes.type_cast(other, self)
      end

      def -(other)
        super SexyScopes.type_cast(other, self)
      end

      def /(other)
        super SexyScopes.type_cast(other, self)
      end
    end
  end
end

module SexyScopes
  module Arel
    module ExpressionMethods
      include ::Arel::Math
      include Wrappers
      include Predications
      include Math
    end
  end
end

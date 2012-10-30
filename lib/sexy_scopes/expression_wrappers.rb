module SexyScopes
  module ExpressionWrappers
    include Wrappers
    include Arel::PredicateMethods
    include Arel::MathMethods
  end
end

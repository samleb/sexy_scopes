module SexyScopes
  module Arel
    extend ActiveSupport::Autoload

    autoload :ExpressionWrappers
    autoload :PredicateWrappers
    autoload :ExpressionMethods
    autoload :PredicateMethods
  end
end

module Arel
  module Nodes
    class Grouping
      # https://github.com/rails/arel/commit/c78227d9b219933f54cecefb99c72bb231fbb8f2
      include Arel::Predications
    end
  end
end

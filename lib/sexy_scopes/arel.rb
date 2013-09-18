module SexyScopes
  module Arel
    extend ActiveSupport::Autoload
    
    autoload :ExpressionMethods
    autoload :PredicateMethods
    
    autoload :Predications
    autoload :Math
  end
end

module Arel
  module Nodes
    # <tt>Grouping</tt> nodes didn't include <tt>Arel::Predications</tt> before
    # {https://github.com/rails/arel/commit/c78227d9b219933f54cecefb99c72bb231fbb8f2 this commit}.
    #
    # Here they are included explicitely just in case they're missing.
    class Grouping
      include Arel::Predications
    end
  end
end

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
    # <tt>Grouping</tt> nodes didn't include <tt>Arel::Predications</tt> before
    # {https://github.com/rails/arel/commit/c78227d9b219933f54cecefb99c72bb231fbb8f2 this commit}.
    #
    # Here they are included explicitely just in case they're missing.
    class Grouping
      include Arel::Predications
    end
    
    # As <tt>SqlLiteral</tt> could be any arbitrary SQL expression, include <tt>Arel::Math</tt>
    # to allow common mathematic operations.
    #
    # @see SexyScopes::ActiveRecord#sql_literal
    class SqlLiteral
      include Arel::Math
    end
  end
  
  # @!visibility private
  class SqlLiteral # :nodoc:
    include Arel::Math
  end
end

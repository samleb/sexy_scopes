module SexyScopes
  module Arel
    extend ActiveSupport::Autoload
    
    autoload :ExpressionMethods
    autoload :PredicateMethods
    
    autoload :Predications
    autoload :Math
  end
end

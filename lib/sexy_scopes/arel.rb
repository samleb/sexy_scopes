require 'arel/visitors_extensions'

module SexyScopes
  module Arel
    autoload :ExpressionMethods, 'sexy_scopes/arel/expression_methods'
    autoload :PredicateMethods, 'sexy_scopes/arel/predicate_methods'
    
    autoload :Predications, 'sexy_scopes/arel/predications'
    autoload :Typecasting, 'sexy_scopes/arel/typecasting'
    autoload :Math, 'sexy_scopes/arel/math'
    
    module Nodes
      autoload :RegexpMatches, 'sexy_scopes/arel/nodes/regexp_matches'
    end
  end
end

require 'active_support/lazy_load_hooks'
require 'sexy_scopes/version'

module SexyScopes
  autoload :Arel, 'sexy_scopes/arel'
  
  class << self
    AREL_6 = ::Arel::VERSION >= '6.0.0'
    
    def extend_expression(expression)
      expression.extend(Arel::ExpressionMethods)
    end
    
    def extend_predicate(predicate)
      predicate.extend(Arel::PredicateMethods)
    end
    
    def arel_6?
      AREL_6
    end
    
    if AREL_6
      def quote(node, attribute = nil)
        ::Arel::Nodes.build_quoted(node, attribute)
      end
    else
      def quote(node, attribute = nil)
        node
      end
    end
    
    alias_method :type_cast, :quote
  end
end

if defined? Rails::Railtie
  require 'sexy_scopes/railtie'
else
  ActiveSupport.on_load :active_record do
    require 'sexy_scopes/active_record'
  end
end

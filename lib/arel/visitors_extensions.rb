require 'arel/visitors'

module Arel
  module Visitors
    class ToSql
      def visit_Regexp(regexp, a = nil)
        visit regexp.source
      end
      
      # Arel >= 4.0
      if instance_method(:visit).arity > 1
        alias_method :sexy_scopes_visit, :visit
      else
        def sexy_scopes_visit(node, attribute = nil)
          visit(node)
        end
      end
    end
    
    class MySQL
      def visit_SexyScopes_Arel_Nodes_RegexpMatches(o, a = nil)
        regexp = o.right
        right = regexp.source
        right = Arel::Nodes::Bin.new(right) unless regexp.casefold?
        "#{sexy_scopes_visit o.left, a} REGEXP #{visit right}"
      end
    end
    
    class PostgreSQL
      def visit_SexyScopes_Arel_Nodes_RegexpMatches(o, a = nil)
        regexp = o.right
        operator = regexp.casefold? ? '~*' : '~'
        right = regexp.source
        "#{sexy_scopes_visit o.left, a} #{operator} #{visit right}"
      end
    end
    
    class Oracle
      def visit_SexyScopes_Arel_Nodes_RegexpMatches(o, a = nil)
        regexp = o.right
        flags = regexp.casefold? ? 'i' : 'c'
        flags << 'm' if regexp.options & Regexp::MULTILINE > 0
        "REGEXP_LIKE(#{sexy_scopes_visit o.left, a}, #{visit regexp.source}, #{visit flags})"
      end
    end
  end
end

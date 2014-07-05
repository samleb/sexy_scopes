require 'arel/visitors'

module Arel
  module Visitors
    class ToSql
      private
      
      def visit_Regexp(regexp, arg = nil)
        source = SexyScopes.quote(regexp.source)
        sexy_scopes_visit source, arg
      end
      
      # Arel >= 4.0
      if instance_method(:visit).arity > 1
        alias_method :sexy_scopes_visit, :visit
      else
        def sexy_scopes_visit(node, arg = nil)
          visit(node)
        end
      end
      
      # Arel >= 6.0
      if instance_method(:accept).arity > 1
        def reduce_visitor?
          true
        end
      else
        def reduce_visitor?
          false
        end
      end
    end
    
    class MySQL
      private
      
      def visit_SexyScopes_Arel_Nodes_RegexpMatches(o, arg = nil)
        regexp = o.right
        right = SexyScopes.quote(regexp.source)
        right = Arel::Nodes::Bin.new(right) unless regexp.casefold?
        if reduce_visitor?
          visit o.left, arg
          arg << ' REGEXP '
          visit right, arg
        else
          "#{sexy_scopes_visit o.left, arg} REGEXP #{visit right}"
        end
      end
    end
    
    class PostgreSQL
      private
      
      def visit_SexyScopes_Arel_Nodes_RegexpMatches(o, arg = nil)
        regexp = o.right
        operator = regexp.casefold? ? '~*' : '~'
        right = SexyScopes.quote(regexp.source)
        if reduce_visitor?
          visit o.left, arg
          arg << SPACE << operator << SPACE
          visit right, arg
        else
          "#{sexy_scopes_visit o.left, arg} #{operator} #{visit right}"
        end
      end
    end
    
    class Oracle
      private
      
      def visit_SexyScopes_Arel_Nodes_RegexpMatches(o, arg = nil)
        regexp = o.right
        flags = regexp.casefold? ? 'i' : 'c'
        flags << 'm' if regexp.options & Regexp::MULTILINE == Regexp::MULTILINE
        if reduce_visitor?
          arg << 'REGEXP_LIKE('
          visit o.left, arg
          arg << COMMA
          visit regexp.source, arg
          arg << COMMA
          visit flags, arg
          arg << ')'
        else
          "REGEXP_LIKE(#{sexy_scopes_visit o.left, arg}, #{visit regexp.source}, #{visit flags})"
        end
      end
    end
  end
end

module Arel
  module Visitors
    class ToSql
      def visit_Regexp(regexp)
        visit regexp.source
      end
    end
    
    class MySQL
      def visit_SexyScopes_Arel_Nodes_RegexpMatches(o)
        regexp = o.right
        right = regexp.source
        right = Arel::Nodes::Bin.new(right) unless regexp.casefold?
        "#{visit o.left} REGEXP #{visit right}"
      end
    end
    
    class PostgreSQL
      def visit_SexyScopes_Arel_Nodes_RegexpMatches(o)
        regexp = o.right
        operator = regexp.casefold? ? '~*' : '~'
        right = regexp.source
        "#{visit o.left} #{operator} #{visit right}"
      end
    end
    
    class Oracle
      def visit_SexyScopes_Arel_Nodes_RegexpMatches(o)
        regexp = o.right
        flags = regexp.casefold? ? 'i' : 'c'
        flags << 'm' if regexp.options & Regexp::MULTILINE > 0
        "REGEXP_LIKE(#{visit o.left}, #{visit regexp.source}, #{visit flags})"
      end
    end
  end
end

require 'arel/visitors'

module Arel
  module Visitors
    # TODO: Extract these methods into modules
    class ToSql
      private

      def visit_Regexp(regexp, collector)
        source = SexyScopes.quote(regexp.source)
        visit source, collector
      end
    end

    class MySQL
      private

      def visit_SexyScopes_Arel_Nodes_RegexpMatches(o, collector)
        regexp = o.right
        right = SexyScopes.quote(regexp.source)
        right = Arel::Nodes::Bin.new(right) unless regexp.casefold?
        visit o.left, collector
        collector << ' REGEXP '
        visit right, collector
      end
    end

    class PostgreSQL
      private

      def visit_SexyScopes_Arel_Nodes_RegexpMatches(o, collector)
        regexp = o.right
        operator = regexp.casefold? ? '~*' : '~'
        right = SexyScopes.quote(regexp.source)
        visit o.left, collector
        collector << SPACE << operator << SPACE
        visit right, collector
      end
    end

    class Oracle
      private

      def visit_SexyScopes_Arel_Nodes_RegexpMatches(o, collector)
        regexp = o.right
        flags = regexp.casefold? ? 'i' : 'c'
        flags << 'm' if regexp.options & Regexp::MULTILINE == Regexp::MULTILINE
        collector << 'REGEXP_LIKE('
        visit o.left, collector
        collector << COMMA
        visit regexp.source, collector
        collector << COMMA
        visit flags, collector
        collector << ')'
      end
    end
  end
end

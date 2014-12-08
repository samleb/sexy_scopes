module SexyScopes
  module Arel
    module Predications
      def eq(other)
        SexyScopes.extend_predicate(super)
      end
      alias == eq

      def in(other)
        SexyScopes.extend_predicate(super)
      end

      def matches(other, *)
        if Regexp === other
          matches_regexp(other)
        else
          SexyScopes.extend_predicate(super)
        end
      end
      alias =~ matches

      def does_not_match(other, *)
        if Regexp === other
          does_not_match_regexp(other)
        else
          SexyScopes.extend_predicate(super)
        end
      end
      alias !~ does_not_match

      def matches_regexp(other)
        predicate = Arel::Nodes::RegexpMatches.new(self, other)
        SexyScopes.extend_predicate(predicate)
      end

      def does_not_match_regexp(other)
        matches_regexp(other).not
      end

      def gteq(other)
        SexyScopes.extend_predicate(super)
      end
      alias >= gteq

      def gt(other)
        SexyScopes.extend_predicate(super)
      end
      alias > gt

      def lt(other)
        SexyScopes.extend_predicate(super)
      end
      alias < lt

      def lteq(other)
        SexyScopes.extend_predicate(super)
      end
      alias <= lteq

      def not_eq(other)
        SexyScopes.extend_predicate(super)
      end
      alias != not_eq
    end
  end
end


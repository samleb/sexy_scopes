module SexyScopes
  module Arel
    module PredicateMethods
      class << self
        private
          def ruby_19_alias(new_name, old_name)
            class_eval "alias #{new_name} #{old_name}" if RUBY_VERSION >= "1.9"
          end
      end
      
      def eq(other)
        extend_predicate(super)
      end
      alias == eq
      
      def in(other)
        extend_predicate(super)
      end
      
      def matches(other)
        extend_predicate(super)
      end
      alias =~ matches
      
      def does_not_match(other)
        extend_predicate(super)
      end
      ruby_19_alias '!~', 'does_not_match'
      
      def gteq(other)
        extend_predicate(super)
      end
      alias >= gteq
      
      def gt(other)
        extend_predicate(super)
      end
      alias > gt
      
      def lt(other)
        extend_predicate(super)
      end
      alias < lt
      
      def lteq(other)
        extend_predicate(super)
      end
      alias <= lteq
      
      def not_eq(other)
        extend_predicate(super)
      end
      ruby_19_alias '!=', 'not_eq'
    end
  end
end


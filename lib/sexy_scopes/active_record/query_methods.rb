module SexyScopes
  module ActiveRecord
    module QueryMethods
      # Adds support for blocks to ActiveRecord `where`.
      #
      # @example
      #   User.where { username =~ 'bob%' }
      #   # is equivalent to:
      #   User.where(User.username =~ 'bob%')
      #
      # The block is evaluated in the context of the current relation, and the resulting expression
      # is used as an argument to `where`, thus allowing a cleaner syntax where you don't have to write
      # the receiver of the method explicitely, in this case: `username` vs `User.username`
      #
      # This form can also be used with relations:
      #
      # @example
      #   post.comments.where { rating > 5 }
      #   # is equivalent to:
      #   post.comments.where(Comment.rating > 5)
      #
      # @raise [ArgumentError] if both arguments and a block are passed
      #
      # @see WhereChainMethods#not
      #
      def where(*args, &block)
        if block
          super(sexy_scopes_build_conditions_from_block(args, block))
        else
          super
        end
      end

      protected

      def sexy_scopes_build_conditions_from_block(args, block)
        raise ArgumentError, "You can't use both arguments and a block" if args.any?
        if block.arity.zero?
          instance_eval(&block)
        else
          block.call(self)
        end
      end

      module WhereChainMethods
        # Adds support for blocks to ActiveRecord `where.not`.
        #
        # @example
        #   User.where.not { username =~ 'bob%' }
        #
        # @raise [ArgumentError] if both arguments and a block are passed
        #
        # @see QueryMethods#where
        #
        def not(*args, &block)
          if block
            conditions = @scope.send(:sexy_scopes_build_conditions_from_block, args, block)
            @scope.where(conditions.not)
          else
            super
          end
        end
      end
    end
  end
end

module SexyScopes
  module Arel
    module Nodes
      class RegexpMatches < ::Arel::Nodes::InfixOperation
        def initialize(left, right)
          right = Regexp.try_convert(right) || Regexp.compile(right.to_s)
          super(:REGEXP, left, right)
        end
      end
    end
  end
end

module SexyScopes
  module Version
    MAJOR = 1
    MINOR = 0
    TINY  = 0
    PRE = 'beta1'

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')

    class << self
      # Allows {Version} to display ({to_s}) and behave ({to_str}) as a string
      def to_str
        STRING
      end
      alias_method :to_s, :to_str
    end
  end

  VERSION = Version::STRING
end

module SexyScopes
  module Version
    MAJOR = 0
    MINOR = 5
    TINY  = 0
    
    STRING = [MAJOR, MINOR, TINY].join('.')
    
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

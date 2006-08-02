RADIANT_ROOT = File.join(File.dirname(__FILE__), "..") unless defined? RADIANT_ROOT

module Radiant
  module Version
    Major = '0'
    Minor = '5'
    Tiny  = '1'
    
    class << self
      def to_s
        [Major, Minor, Tiny].join('.')
      end
      alias :to_str :to_s
    end
  end
end
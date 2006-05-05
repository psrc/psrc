module CachingTestHelper
  class FakePageCache
    attr_accessor :cleared, :expired_path, :expired_paths
    
    def initialize
      @expired_paths = []
    end
    
    def clear
      @cleared = true
    end
    
    def expire(path)
      @expired_paths << path
      @expired_path = path
    end
    
    def cleared
      @cleared || false
    end
  end
end
class ArchiveFinder
  def initialize(&block)
    @block = block
  end

  def find(method, options = {})
    @block.call(method, options)
  end
  
  class << self
    def year_finder(finder, year)
      new do |method, options|
        add_condition(options, "YEAR(published_at) = ?", year)
        finder.find(method, options)
      end
    end
    
    def month_finder(finder, year, month)
      finder = year_finder(finder, year)
      new do |method, options|
        add_condition(options, "MONTH(published_at) = ?", month)
        finder.find(method, options)
      end
    end
    
    def day_finder(finder, year, month, day)
      finder = month_finder(finder, year, month)
      new do |method, options|
        add_condition(options, "DAY(published_at) = ?", day)
        finder.find(method, options)
      end
    end
    
    private

      def concat_conditions(a, b)
        sql = "(#{ [a.shift, b.shift].compact.join(") AND (") })"
        params = a + b
        [sql, *params]
      end
    
      def add_condition(options, *condition)
        old = options[:conditions] || []
        conditions = concat_conditions(old, condition)
        options[:conditions] = conditions
        options
      end
  end
end
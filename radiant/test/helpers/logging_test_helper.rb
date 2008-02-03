module LoggingTestHelper
  def log_matches(regexp)
    result = false
    open(RAILS_ROOT + '/log/test.log') do |f|
      lines = f.readlines.to_s
      result = true if regexp.match(lines)
    end
    result
  end
end
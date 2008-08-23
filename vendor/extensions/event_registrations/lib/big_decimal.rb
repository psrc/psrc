class BigDecimal
  # this works around http://code.whytheluckystiff.net/syck/ticket/24 until it gets fixed..
  alias :_original_to_yaml :to_yaml
  def to_yaml (opts={},&block)
    to_s.to_yaml(opts,&block)
  end
end


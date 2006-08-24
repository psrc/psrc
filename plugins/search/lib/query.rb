class Query < String

  def initialize(options = {})
    super()
    configuration = { 'fields' => ['title'] + Page::DEFAULT_PARTS, 'query' => '' }
    configuration.update(options) if options.is_a?(Hash)
    @fields = configuration['fields'].collect { |field| field.strip }
    @tokens = configuration['query'].split.collect { |word| word.strip }
    self.replace(%{#{@fields.join('|')}:(#{@tokens.join(' ')})})
  end

end

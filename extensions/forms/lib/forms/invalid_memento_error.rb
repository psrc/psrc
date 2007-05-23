module Forms
  class InvalidMementoError < RuntimeError
    def initialize(memento)
      super "Invalid form memento. Expecting format of '<model_name>:<page_url>'. Received value: <#{memento}>"
    end
  end
end
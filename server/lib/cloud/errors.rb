module Cloud
  class Errors
    include Enumerable

    attr_reader :messages

    def initialize
      @messages = []
    end

    def add(message)
      messages.push(message) if message.present?
    end

    def each
      messages.each do |message|
        yield message
      end
    end

    def size
      messages.size
    end

    def empty?
      messages.empty?
    end
    alias_method :blank?, :empty?
  end
end

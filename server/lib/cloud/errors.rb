module Cloud
  class Errors
    include Enumerable
    extend Forwardable

    attr_reader :messages
    def_delegator :messages, :join

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

    def to_a
      messages
    end

  end
end

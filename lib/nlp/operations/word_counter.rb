# frozen_string_literal: true

module NLP
  module Operations
    class WordCounter
      def self.word_count(value)
        Counter.call(tokenize(value))
      end

      def self.tokenize(value)
        return value if value.is_a? Enumerable

        WordTokenizer.call(value)
      end

      def self.call(value)
        method(:word_count).call(value)
      end
    end
  end
end

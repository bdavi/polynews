# frozen_string_literal: true

module NLP
  module Operations
    class WordSizeFilter
      def self.min_length(min_length)
        new(min_length)
      end

      attr_reader :min_length

      def initialize(min_length)
        @min_length = min_length
      end

      def call(words)
        words.select { |word| word.length >= min_length }
      end
    end
  end
end

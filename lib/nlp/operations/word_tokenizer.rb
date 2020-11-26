# frozen_string_literal: true

module NLP
  module Operations
    WORD_BREAK_PATTERN = /[^\w\s]*\s+[^\w\s]*|\W+\z/.freeze

    WORD_TOKENIZE_OPERATION = ->(str) { str.split(WORD_BREAK_PATTERN) }

    class WordTokenizer < Pipeline::RecursiveOperation
      def self.operation
        WORD_TOKENIZE_OPERATION
      end
    end
  end
end

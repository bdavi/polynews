# frozen_string_literal: true

module NLP
  module TextOperations
    WORD_TOKENIZE_OPERATION = ->(str) { str.split(/[^\w\s]*\s+[^\w\s]*/) }

    class WordTokenize < Pipeline::RecursiveOperation
      def self.operation
        WORD_TOKENIZE_OPERATION
      end
    end
  end
end

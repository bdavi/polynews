# frozen_string_literal: true

module NLP
  module Operations
    class WordTokenizer < Pipeline::RecursiveOperation
      WORD_BREAK_PATTERN = /(?<=\w)\s(?=\w)|[\W\s]{2,}|\W+\z/.freeze

      def self.tokenize(string)
        string.split(WORD_BREAK_PATTERN)
      end

      def self.operation
        method(:tokenize)
      end
    end
  end
end

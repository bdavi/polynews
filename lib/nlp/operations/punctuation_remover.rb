# frozen_string_literal: true

module NLP
  module Operations
    REMOVE_PUNCTUATION_OPERATION = ->(str) { str.gsub(/[^\w\s]/, '') }

    class PunctuationRemover < Pipeline::RecursiveOperation
      def self.operation
        REMOVE_PUNCTUATION_OPERATION
      end
    end
  end
end

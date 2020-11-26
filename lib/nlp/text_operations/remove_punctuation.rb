# frozen_string_literal: true

module NLP
  module TextOperations
    REMOVE_PUNCTUATION_OPERATION = ->(str) { str.gsub(/[^\w\s]/, '') }

    class RemovePunctuation < Pipeline::RecursiveOperation
      def self.operation
        REMOVE_PUNCTUATION_OPERATION
      end
    end
  end
end

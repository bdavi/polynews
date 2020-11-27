# frozen_string_literal: true

module NLP
  module Operations
    class PunctuationRemover < Pipeline::RecursiveOperation
      def self.remove_punctuation(string)
        string.gsub(/[^\w\s]/, '')
      end

      def self.operation
        method(:remove_punctuation)
      end
    end
  end
end

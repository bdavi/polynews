# frozen_string_literal: true

module NLP
  module TextOperations
    DOWNCASE_OPERATION = ->(str) { str.downcase }

    class Downcase < Pipeline::RecursiveOperation
      def self.operation
        DOWNCASE_OPERATION
      end
    end
  end
end

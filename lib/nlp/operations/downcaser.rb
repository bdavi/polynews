# frozen_string_literal: true

module NLP
  module Operations
    DOWNCASE_OPERATION = ->(str) { str.downcase }

    class Downcaser < Pipeline::RecursiveOperation
      def self.operation
        DOWNCASE_OPERATION
      end
    end
  end
end

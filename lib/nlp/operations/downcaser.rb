# frozen_string_literal: true

module NLP
  module Operations
    class Downcaser < Pipeline::RecursiveOperation
      def self.downcase(string)
        string.downcase
      end

      def self.operation
        method(:downcase)
      end
    end
  end
end

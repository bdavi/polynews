# frozen_string_literal: true

module NLP
  module Operations
    class Transliterater < Pipeline::RecursiveOperation
      def self.tansliterate(string)
        ActiveSupport::Inflector.transliterate(string)
      end

      def self.operation
        method(:tansliterate)
      end
    end
  end
end

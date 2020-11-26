# frozen_string_literal: true

module NLP
  module TextOperations
    TRANSLITERATE_OPERATION = ->(str) { ActiveSupport::Inflector.transliterate(str) }

    class Transliterate < Pipeline::RecursiveOperation
      def self.operation
        TRANSLITERATE_OPERATION
      end
    end
  end
end

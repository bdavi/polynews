# frozen_string_literal: true

module NLP
  module Operations
    TRANSLITERATE_OPERATION = ->(str) { ActiveSupport::Inflector.transliterate(str) }

    class Transliterater < Pipeline::RecursiveOperation
      def self.operation
        TRANSLITERATE_OPERATION
      end
    end
  end
end

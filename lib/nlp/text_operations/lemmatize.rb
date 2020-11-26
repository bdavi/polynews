# frozen_string_literal: true

require 'lemmatizer'

module NLP
  module TextOperations
    LEMMATIZER_INSTANCE = Lemmatizer.new

    LEMMATIZE_OPERATION = ->(str) { LEMMATIZER_INSTANCE.lemma(str) }

    class Lemmatize < Pipeline::RecursiveOperation
      def self.operation
        LEMMATIZE_OPERATION
      end
    end
  end
end

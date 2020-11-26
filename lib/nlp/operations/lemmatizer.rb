# frozen_string_literal: true

require 'lemmatizer'

module NLP
  module Operations
    LEMMATIZER_INSTANCE = Lemmatizer.new

    LEMMATIZE_OPERATION = ->(str) { LEMMATIZER_INSTANCE.lemma(str) }

    class Lemmatizer < Pipeline::RecursiveOperation
      def self.operation
        LEMMATIZE_OPERATION
      end
    end
  end
end

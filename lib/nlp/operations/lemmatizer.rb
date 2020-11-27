# frozen_string_literal: true

require 'lemmatizer'

module NLP
  module Operations
    GEM_LEMMATIZER_INSTANCE = Lemmatizer.new

    class Lemmatizer < Pipeline::RecursiveOperation
      def self.lemmatize(string)
        GEM_LEMMATIZER_INSTANCE.lemma(string)
      end

      def self.operation
        method(:lemmatize)
      end
    end
  end
end

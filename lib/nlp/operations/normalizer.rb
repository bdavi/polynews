# frozen_string_literal: true

module NLP
  module Operations
    class Normalizer < Pipeline::Base
      use WordTokenizer
      use Transliterater
      use Downcaser
      use PunctuationRemover
      use StopWordRemover
      use Lemmatizer
    end
  end
end

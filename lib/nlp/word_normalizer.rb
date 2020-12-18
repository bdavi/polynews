# frozen_string_literal: true

module NLP
  class WordNormalizer < Pipeline::Base
    include NLP::Operations

    apply  WordTokenizer
    map_by Transliterater
    map_by Downcaser
    map_by PunctuationRemover
    apply  StopWordRemover
    map_by WordLemmatizer
    apply  WordSizeFilter.min_length(3)
  end
end

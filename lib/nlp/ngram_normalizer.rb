# frozen_string_literal: true

module NLP
  class NgramNormalizer < Pipeline::Base
    include NLP::Operations
    extend NLP::Operations

    apply  SentenceTokenizer
    map_by WordNormalizer
    map_by NGramGenerator.size(2)
    apply  Flattener.depth(1)
  end
end

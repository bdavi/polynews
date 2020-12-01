# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NLP::BOW::TermFrequencyAlgorithm do
  describe '.call' do
    it 'returns the token count vector for the document' do
      model = NLP::BOW::Model.new(
        tokenizer: NLP::Operations::WordTokenizer,
        algorithm: described_class
      )
      model.add_document 'one fish two fish.'
      model.add_document 'red fish'

      result = described_class.call(model, 'fish red fish')

      expect(result).to eq Vector[0.6666666666666666, 0.0, 0.3333333333333333, 0.0]
    end
  end
end

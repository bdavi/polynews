# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NLP::BOW::TfIdfAlgorithm do
  describe '.call' do
    context 'when the token is in the document' do
      it 'returns the token count vector for the document' do
        model = NLP::BOW::Model.new(
          tokenizer: NLP::WordNormalizer,
          algorithm: described_class
        )
        model.add_document 'one fish two fish.'
        model.add_document 'red fish'

        result = described_class.call(model, 'fish red fish')

        expect(result).to eq Vector[0.0, 0.23104906018664842]
      end
    end
  end
end

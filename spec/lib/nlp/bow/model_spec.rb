# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NLP::BOW::Model do
  describe '#add_document' do
    it 'updates the vocabulary and counts' do
      model = described_class.new(
        tokenizer: NLP::Operations::WordTokenizer
      )
      model.add_document 'One fish, two fish.'
      model.add_document 'Red fish!!'

      expected_vocabulary = {
        'One' => { documents_containing: 1, count: 1 },
        'fish' => { documents_containing: 2, count: 3 },
        'two' => { documents_containing: 1, count: 1 },
        'Red' => { documents_containing: 1, count: 1 }
      }

      expect(model.vocabulary).to eq expected_vocabulary
      expect(model.document_count).to eq 2
      expect(model.aggregate_document_length).to eq 6
    end
  end

  describe '#vector_for' do
    it 'returns the algorithm generated values' do
      algorithm = NLP::BOW::TermFrequencyAlgorithm
      model = described_class.new(
        tokenizer: NLP::Operations::WordTokenizer,
        algorithm: algorithm
      )
      document = 'fish red fish'
      vector_double = class_double('Vector')
      allow(algorithm).to receive(:call).with(model, document).and_return(vector_double)

      result = model.vector_for(document)

      expect(result).to eq vector_double
    end
  end
end

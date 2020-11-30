# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NLP::BOW::Model do
  describe '#add_document' do
    it 'updates the vocabulary and counts' do
      model = described_class.new

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
end

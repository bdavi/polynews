# frozen_string_literal: true

RSpec.describe NLP::FeatureMatrix do
  describe '#average_vector' do
    it 'returns a vector that is the average of the rows' do
      matrix = described_class[
        [3, 2, 4, 1],
        [6, 5, 4, 1],
        [9, 9, 4, 1]
      ]

      expect(matrix.average_vector).to eq Vector[6.0, 5.333333333333333, 4.0, 1.0]
    end
  end
end

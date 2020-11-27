# frozen_string_literal: true

RSpec.describe NLP::Operations::WordSizeFilter do
  describe '#call' do
    it 'removes sords shorter than min_length' do
      input = %w[a bb ccc dddd eeeee]
      filter = described_class.new(3)

      result = filter.call(input)

      expect(result).to eq %w[ccc dddd eeeee]
    end
  end

  describe '.min_length' do
    it 'returns a new instance with min_length set' do
      filter = described_class.min_length(4)

      expect(filter).to be_a described_class
      expect(filter.min_length).to eq 4
    end
  end
end

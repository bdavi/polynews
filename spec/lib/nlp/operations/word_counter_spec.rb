# frozen_string_literal: true

RSpec.describe NLP::Operations::WordCounter do
  context 'when input is a string' do
    it 'returns a hash with the word counts' do
      string = 'One fish, two fish, red fish, blue fish.'

      result = described_class.call(string)

      expected = { 'One' => 1, 'blue' => 1, 'fish' => 4, 'red' => 1, 'two' => 1 }
      expect(result).to eq expected
    end
  end

  context 'when input is Enumberable' do
    it 'returns a hash with the word counts' do
      array = %w[One fish two fish red fish blue fish]

      result = described_class.call(array)

      expected = { 'One' => 1, 'blue' => 1, 'fish' => 4, 'red' => 1, 'two' => 1 }
      expect(result).to eq expected
    end
  end
end

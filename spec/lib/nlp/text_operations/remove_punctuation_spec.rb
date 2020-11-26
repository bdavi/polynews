# frozen_string_literal: true

RSpec.describe NLP::TextOperations::RemovePunctuation do
  it 'recursively removes punctuation from strings' do
    input = ['a.Bc//', 'DEf', %w[G-h""i 123 x&2]]

    result = described_class.call(input)

    expect(result).to eq ['aBc', 'DEf', %w[Ghi 123 x2]]
  end
end

# frozen_string_literal: true

RSpec.describe NLP::TextOperations::Transliterate do
  it 'recursively transliterates strings' do
    input = ['abc', 'Qué', %w[baño 123]]

    result = described_class.call(input)

    expect(result).to eq ['abc', 'Que', %w[bano 123]]
  end
end

# frozen_string_literal: true

RSpec.describe NLP::TextOperations::Lemmatize do
  it 'recursively lematizes strings' do
    input = ['dogs', 'hired', %w[hotter slow]]

    result = described_class.call(input)

    expect(result).to eq ['dog', 'hire', %w[hot slow]]
  end
end

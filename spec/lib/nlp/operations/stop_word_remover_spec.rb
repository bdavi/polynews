# frozen_string_literal: true

RSpec.describe NLP::Operations::StopWordRemover do
  it 'recursively removes punctuation from strings' do
    input = %w[The cat in the hat]

    result = described_class.call(input)

    expect(result).to eq %w[The cat hat]
  end
end

# frozen_string_literal: true

RSpec.describe NLP::NgramNormalizer do
  it 'returns ngrams from the normalized sentences' do
    input = 'The cat in the hat is excellent! Red fish, blue fish.'

    result = described_class.call(input)

    expected = [
      %w[cat hat],
      %w[hat excellent],
      %w[red fish],
      %w[fish blue],
      %w[blue fish]
    ]

    expect(result).to eq expected
  end
end

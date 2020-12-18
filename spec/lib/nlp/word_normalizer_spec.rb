# frozen_string_literal: true

RSpec.describe NLP::WordNormalizer do
  it 'normalizes the string' do
    input = 'aBc baño the hotter. a bb'

    result = described_class.call(input)

    expect(result).to eq %w[abc bano hot]
  end
end

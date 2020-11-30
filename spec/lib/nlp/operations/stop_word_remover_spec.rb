# frozen_string_literal: true

RSpec.describe NLP::Operations::StopWordRemover do
  it 'removes stop words' do
    input = %w[The cat in the hat is a the]

    result = described_class.call(input)

    expect(result).to eq %w[The cat hat]
  end

  it 'removes stop words recursively' do
    input = [
      %w[one fish two fish],
      %w[red fish blue fish],
      %w[the is a]
    ]

    result = described_class.call(input)

    expect(result).to eq [
      %w[fish fish],
      %w[red fish blue fish]
    ]
  end
end

# frozen_string_literal: true

RSpec.describe NLP::Operations::Downcaser do
  it 'recursively downcases strings' do
    input = ['aBc', 'DEf', %w[Ghi 123]]

    result = described_class.call(input)

    expect(result).to eq ['abc', 'def', %w[ghi 123]]
  end
end

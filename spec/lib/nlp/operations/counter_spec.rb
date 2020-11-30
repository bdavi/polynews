# frozen_string_literal: true

RSpec.describe NLP::Operations::Counter do
  it 'returns a hash with the counts' do
    array = [
      'one',
      %w[two fish],
      'red',
      'fish',
      'blue',
      'fish',
      %w[two fish]
    ]

    result = described_class.call(array)

    expected = {
      'one' => 1,
      %w[two fish] => 2,
      'red' => 1,
      'fish' => 2,
      'blue' => 1
    }
    expect(result).to eq expected
  end
end

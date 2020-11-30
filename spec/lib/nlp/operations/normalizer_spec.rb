# frozen_string_literal: true

RSpec.describe NLP::Operations::Normalizer do
  it 'normalizes the string' do
    input = 'aBc baño the hotter. a bb'

    result = described_class.call(input)

    expect(result).to eq %w[abc bano hot]
  end

  it 'normalizes recursively' do
    sentences = [
      'Dr. Smith treated 10.6 million patients in one year.',
      "Then she moved\nto the U.S.A.",
      'Was that a good plan?',
      "Her batting average is .9 for this... if you can\nbelieve that!",
      'I do!',
      'This has a sentence ending ellipse...',
      'New sentence here!!!'
    ]

    result = described_class.call(sentences)

    expect(result).to eq [
      %w[smith treat 106 patient year],
      %w[move usa],
      %w[good plan],
      %w[bat average],
      %w[sentence ellipse],
      %w[sentence]
    ]
  end
end

# frozen_string_literal: true

RSpec.describe NLP::Operations::SentenceTokenizer do
  it 'splits strings into single word tokens' do
    string = <<~TEXT
      Dr. Smith treated 10.6 million patients in one year. Then she moved
      to the U.S.A. Was that a good plan? Her batting average is .9 for this... if you can
      believe that! I do!
      This has a sentence ending ellipse... New sentence here!!!
    TEXT

    result = described_class.call(string)

    expect(result).to eq [
      'Dr. Smith treated 10.6 million patients in one year.',
      "Then she moved\nto the U.S.A.",
      'Was that a good plan?',
      "Her batting average is .9 for this... if you can\nbelieve that!",
      'I do!',
      'This has a sentence ending ellipse...',
      'New sentence here!!!'
    ]
  end
end

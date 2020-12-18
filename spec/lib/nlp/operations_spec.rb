# frozen_string_literal: true

RSpec.describe NLP::Operations do
  describe 'Counter' do
    it 'returns a hash with the counts' do
      array = ['one', %w[two fish], 'fish', 'fish', %w[two fish]]

      result = described_module::Counter.call(array)

      expected = { 'one' => 1, %w[two fish] => 2, 'fish' => 2 }
      expect(result).to eq expected
    end
  end

  describe 'WordLemmatizer' do
    it 'returns lemmatizes' do
      expect(described_module::WordLemmatizer.call('hired')).to eq 'hire'
    end
  end

  describe 'PunctuationRemover' do
    it 'removes punctuation from string' do
      expect(described_module::PunctuationRemover.call('a.b/c""')).to eq 'abc'
    end
  end

  describe 'SentenceTokenizer' do
    it 'splits strings into sentence' do
      string = <<~TEXT
        Dr. Smith treated 10.6 million patients in one year. Then she moved
        to the U.S.A. Was that a good plan? Her batting average is .9 for this... if you can
        believe that! I do!
        This has a sentence ending ellipse... New sentence here!!!
      TEXT

      result = described_module::SentenceTokenizer.call(string)

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

  describe 'WordTokenizer' do
    it 'splits strings into single word tokens' do
      string = %(Jane said, "it isn't A.B.". There's a 2nd –) \
                 " $225 million sentence here\nwith more!!)"

      result = described_module::WordTokenizer.call(string)

      expect(result).to eq ['Jane', 'said', 'it', "isn't", 'A.B',
                            "There's", 'a', '2nd', '225', 'million',
                            'sentence', 'here', 'with', 'more']
    end
  end

  describe '#generate_ngrams' do
    context 'when there are enough elements' do
      it 'creates ngrams of the specified size' do
        array = %i[a b c]

        result = described_module::NGramGenerator.size(2).call(array)

        expect(result).to eq [%i[a b], %i[b c]]
      end
    end

    context "when there aren't enough elements" do
      it 'returns an empty array' do
        array = %i[a b c]

        result = described_module::NGramGenerator.size(4).call(array)

        expect(result).to eq []
      end
    end
  end

  describe 'StopWordRemover' do
    it 'removes words in the stop word dictionary' do
      input = %w[The cat in the hat is a the]

      result = described_module::StopWordRemover.call(input)

      expect(result).to eq %w[The cat hat]
    end
  end

  describe 'Transliterater' do
    it 'replaces non-ascii chars with corresponding characters' do
      input = 'abc Qué baño 123'

      result = described_module::Transliterater.call(input)

      expect(result).to eq 'abc Que bano 123'
    end
  end

  describe 'Downcaser' do
    it 'downcases the string' do
      input = 'aB CCC dEf G'

      result = described_module::Downcaser.call(input)

      expect(result).to eq 'ab ccc def g'
    end
  end
end

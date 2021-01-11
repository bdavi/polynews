# frozen_string_literal: true

require 'lemmatizer'

module NLP
  module Operations
    GEM_LEMMATIZER_INSTANCE = Lemmatizer.new

    SENTENCE_BREAK_PATTERN = /(?<![A-Z][a-z]\.)(?<!\w\.\w)(?<=[?!.])\s+(?=[A-Z])/.freeze
    WORD_BREAK_PATTERN = /(?<=\w)\s(?=\w)|[\W\s]{2,}|\W+\z/.freeze

    STOP_WORD_DICTIONARY_PATH = File.join(File.dirname(__FILE__), 'stop_word_dictionary.txt')
    STOP_WORD_DICTIONARY = IO.read(STOP_WORD_DICTIONARY_PATH).split("\n")

    Downcaser = ->(string) { string.downcase }

    PunctuationRemover = ->(string) { string.gsub(/[^\w\s]/, '') }

    SentenceTokenizer = ->(string) { string.split(SENTENCE_BREAK_PATTERN).map(&:strip) }

    StopWordRemover = ->(words) { words.reject { |word| STOP_WORD_DICTIONARY.include?(word) } }

    Transliterater = ->(string) { ActiveSupport::Inflector.transliterate(string) }

    WordLemmatizer = ->(string) { GEM_LEMMATIZER_INSTANCE.lemma(string) }

    WordTokenizer = ->(string) { string.split(WORD_BREAK_PATTERN) }

    Counter = lambda do |array|
      array.each_with_object(Hash.new(0)) { |name, hash| hash[name] += 1 }
    end

    class Flattener
      def self.depth(depth)
        ->(array) { array.flatten(depth) }
      end
    end

    class NGramGenerator
      def self.size(ngram_size)
        ->(array) { array.each_cons(ngram_size).to_a }
      end
    end

    class WordSizeFilter
      def self.min_length(length)
        ->(array) { array.reject { |element| element.length < length } }
      end
    end
  end
end

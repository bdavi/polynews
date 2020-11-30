# frozen_string_literal: true

# require 'nlp/operations'

module NLP
  module BOW
    class Model
      include NLP::Operations

      attr_reader :vocabulary, :document_count, :aggregate_document_length,
                  :tokenizer

      def initialize(tokenizer = WordTokenizer)
        @tokenizer = tokenizer
        @vocabulary = default_vocabulary
        @document_count = 0
        @aggregate_document_length = 0
      end

      def add_document(document)
        tokens = tokenizer.call(document)
        counts = Counter.call(tokens)

        update_vocabulary(counts)
        @document_count += 1
      end

      private

      def update_vocabulary(counts)
        counts.each do |word, count|
          vocabulary[word][:count] += count
          vocabulary[word][:documents_containing] += 1
          @aggregate_document_length += count
        end
      end

      def default_vocabulary
        Hash.new do |hash, key|
          hash[key] = { count: 0, documents_containing: 0 }
        end
      end
    end
  end
end

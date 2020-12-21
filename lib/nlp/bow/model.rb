# frozen_string_literal: true

require 'matrix'

module NLP
  module BOW
    class Model
      include NLP::Operations

      attr_reader :vocabulary, :document_count, :aggregate_document_length,
                  :tokenizer, :sorted_tokens, :algorithm

      def initialize(tokenizer: WordNormalizer, algorithm: TfIdfAlgorithm)
        @tokenizer = tokenizer
        @algorithm = algorithm
        @vocabulary = default_vocabulary
        @sorted_tokens = nil
        @document_count = 0
        @aggregate_document_length = 0
      end

      def add_document(document)
        counts = generate_counts(document)
        update_vocabulary(counts)
        @document_count += 1
      end

      def vector_for(document)
        algorithm.call(self, document)
      end

      def generate_counts(document)
        tokens = tokenizer.call(document)
        Counter.call(tokens)
      end

      def zero_vector
        Vector.zero(sorted_tokens.count)
      end

      private

      def update_vocabulary(counts)
        counts.each do |word, count|
          vocabulary[word][:count] += count
          vocabulary[word][:documents_containing] += 1
          @aggregate_document_length += count
        end
        @sorted_tokens = vocabulary.keys.sort
      end

      def default_vocabulary
        Hash.new do |hash, key|
          hash[key] = { count: 0, documents_containing: 0 }
        end
      end
    end
  end
end

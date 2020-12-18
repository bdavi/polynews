# frozen_string_literal: true

module NLP
  module BOW
    class TfIdfAlgorithm
      attr_reader :model, :document, :document_token_counts, :vector_length,
                  :document_total_tokens

      def initialize(model, document)
        @model = model
        @document = document
        @document_token_counts = model.generate_counts(document)
        @document_total_tokens = document_token_counts.values.sum
        @vector_length = model.sorted_tokens.count

        call
      end

      def self.call(model, document)
        new(model, document).call
      end

      def call
        model.zero_vector.tap do |vector|
          model.sorted_tokens.each_with_index do |token, i|
            vector[i] = token_tf_idf(token)
          end
        end
      end

      private

      def token_tf_idf(token)
        document_token_count = document_token_counts.fetch(token, 0)

        token_tf = tf(document_token_count, document_total_tokens)
        token_idf = idf(model.document_count, model.vocabulary[token][:documents_containing])

        token_tf * token_idf
      end

      def tf(document_token_count, document_total_tokens)
        return 0.0 if document_total_tokens.zero?

        document_token_count.fdiv(document_total_tokens)
      end

      def idf(total_document_count, number_of_documents_containing_token)
        Math.log(
          total_document_count.fdiv(
            number_of_documents_containing_token
          )
        )
      end
    end
  end
end

# frozen_string_literal: true

module NLP
  module BOW
    class TermFrequencyAlgorithm
      def self.call(model, document)
        token_counts = model.generate_counts(document)
        total_count = token_counts.values.sum.to_f

        return model.zero_vector if total_count.zero?

        model.zero_vector.tap do |vector|
          model.sorted_tokens.each_with_index do |token, i|
            count = token_counts.fetch(token, 0)
            vector[i] = count.fdiv(total_count)
          end
        end
      end
    end
  end
end

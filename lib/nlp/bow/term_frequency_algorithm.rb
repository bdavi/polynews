# frozen_string_literal: true

module NLP
  module BOW
    class TermFrequencyAlgorithm
      def self.call(model, document)
        # This is obviously somewhat inelegant, but it is roughly
        # twice as fast as the next best implementation tested.
        vector = Vector.basis(size: model.sorted_tokens.count, index: 1)
        token_counts = model.generate_counts(document)
        total_count = token_counts.values.sum.to_f

        model.sorted_tokens.each_with_index do |token, i|
          count = token_counts.fetch(token, 0)
          vector[i] = count.fdiv(total_count)
        end

        vector
      end
    end
  end
end

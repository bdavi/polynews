# frozen_string_literal: true

require 'matrix'

module NLP
  class FeatureMatrix < Matrix
    def average_row
      return rows.first if rows.count < 2

      rows.inject { |combined, v| combined.zip(v) }
        .map(&:flatten)
        .map { |arr| arr.sum.fdiv(rows.count) }
    end

    def average_vector
      return nil unless average_row

      Vector.elements(average_row, false)
    end
  end
end

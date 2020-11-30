# frozen_string_literal: true

module NLP
  module Operations
    class WordSizeFilter
      attr_reader :min_length

      def initialize(min_length)
        @min_length = min_length
      end

      def call(arg)
        if arg.is_a? Enumerable
          arg.each { |value| call(value) }
          arg.delete_if { |value| value.is_a?(String) && value.length < min_length }
        else
          arg
        end
      end

      def self.min_length(min_length)
        new(min_length)
      end
    end
  end
end

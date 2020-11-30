# frozen_string_literal: true

module NLP
  module Operations
    class Counter
      def self.count(value)
        value.each_with_object(Hash.new(0)) do |name, hash|
          hash[name] += 1
        end
      end

      def self.call(value)
        method(:count).call(value)
      end
    end
  end
end

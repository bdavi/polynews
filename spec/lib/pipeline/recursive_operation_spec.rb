# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pipeline::RecursiveOperation do
  describe '#call' do
    context 'when called on a scalar' do
      it 'applies the operation and returns the result' do
        add_one = ->(val) { val + 1 }
        operation = described_class.new(add_one)

        result = operation.call(3)

        expect(result).to eq 4
      end
    end

    context 'when called on an enumerable' do
      it 'returns a new array created by recursively mapping the operation over the inputs' do
        add_one = ->(val) { val + 1 }
        operation = described_class.new(add_one)
        input = [3, [4, 5], [6, [7, 8]]]

        result = operation.call(input)

        expect(result).to eq [4, [5, 6], [7, [8, 9]]]
        expect(input).to eq [3, [4, 5], [6, [7, 8]]]
      end
    end
  end
end

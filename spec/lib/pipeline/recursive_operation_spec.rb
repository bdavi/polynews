# frozen_string_literal: true

RSpec.describe Pipeline::RecursiveOperation do
  describe '.call' do
    context 'when called on a scalar' do
      it 'applies the operation and returns the result' do
        operation_class = Class.new(described_class) do
          def self.operation
            ->(val) { val + 1 }
          end
        end

        result = operation_class.call(3)

        expect(result).to eq 4
      end
    end

    context 'when called on an enumerable' do
      it 'returns a new array created by recursively mapping the operation over the inputs' do
        operation_class = Class.new(described_class) do
          def self.operation
            ->(val) { val + 1 }
          end
        end
        input = [3, [4, 5], [6, [7, 8]]]

        result = operation_class.call(input)

        expect(result).to eq [4, [5, 6], [7, [8, 9]]]
        expect(input).to eq [3, [4, 5], [6, [7, 8]]]
      end
    end
  end

  describe '#call' do
    context 'when called on a scalar' do
      it 'applies the operation and returns the result' do
        operation = ->(val) { val + 1 }
        recursive_operation = described_class.new(operation)

        result = recursive_operation.call(3)

        expect(result).to eq 4
      end
    end

    context 'when called on an enumerable' do
      it 'returns a new array created by recursively mapping the operation over the inputs' do
        operation = ->(val) { val + 1 }
        recursive_operation = described_class.new(operation)
        input = [3, [4, 5], [6, [7, 8]]]

        result = recursive_operation.call(input)

        expect(result).to eq [4, [5, 6], [7, [8, 9]]]
        expect(input).to eq [3, [4, 5], [6, [7, 8]]]
      end
    end
  end
end

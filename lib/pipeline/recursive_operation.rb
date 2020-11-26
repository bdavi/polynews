# frozen_string_literal: true

module Pipeline
  # Recursive operations are initialized with an operation/callable which
  # operates on a scalar.
  #
  # When called on a scalar, it simply applies the operation and returns the result.
  #
  # When called on an enumerable, it returns a new array created by recursively
  # mapping the operation over the inputs.
  class RecursiveOperation
    attr_reader :operation

    def initialize(operation)
      @operation = operation
    end

    def call(val)
      if val.is_a? Enumerable
        val.map { |element| call(element) }
      else
        operation.call(val)
      end
    end
  end
end

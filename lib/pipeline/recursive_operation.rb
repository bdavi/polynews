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
    def self.recursively_call(operation, value)
      if value.is_a? Enumerable
        value.map { |element| recursively_call(operation, element) }
      else
        operation.call(value)
      end
    end

    ############################################################################
    # Derived class usage:
    ############################################################################
    # class StripOperation < Pipeline::RecursiveOperation
    #   def self.operation
    #     ->(val) { val.strip }
    #   end
    # end
    #
    # StripOperation.call(['  abc   ', ['123', '  def']])
    # => ['abc', ['123', 'def']]
    ############################################################################

    # Implement in derived class
    # def self.operation
    #   # return a callable
    # end

    def self.call(value)
      recursively_call(operation, value)
    end

    ############################################################################
    # Instance usage
    ############################################################################
    # strip_operation = ->(val) { val.strip }
    # strip_recursive_operation = RecursiveOperation.new(strip_operation)
    #
    # strip_recursive_operation.call(['  abc   ', ['123', '  def']])
    # => ['abc', ['123', 'def']]
    ############################################################################

    attr_reader :operation

    def initialize(operation)
      @operation = operation
    end

    def call(value)
      self.class.recursively_call(operation, value)
    end
  end
end

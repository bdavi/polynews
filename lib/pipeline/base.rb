# frozen_string_literal: true

module Pipeline
  # Pipelines allow for simple chaining of callable operations.
  #
  # When called, a pipeline accepts an initial value and sequentially applies
  # each operation to the result of the prior.
  #
  # The only requirement of an operation is that it respond to `call`, which
  # means pipelines themselves can be operations in other pipelines.
  #
  # Pipelines DO NOT verify operation compatibility or handle errors so be sure
  # to test and error handle appropriately.
  #
  # Example for normalizing text to be processing:
  #
  # Strip = ->(str) { str.downcase }
  # Downcase = ->(str) { str.strip }
  #
  # class CleanUp < Pipeline::Base
  #   use Strip
  #   use Downcase
  # end
  #
  # CleanUp.call('   SoMe Text goes Here  ')
  # => "some text goes here"

  # rubocop:disable ThreadSafety/InstanceVariableInClassMethod
  class Base
    attr_reader :operations

    def self.use(operation)
      @operations ||= []
      @operations << operation
    end

    def self.call(arg)
      @operations.inject(arg) do |result, operation|
        operation.call(result)
      end
    end
  end
  # rubocop:enable ThreadSafety/InstanceVariableInClassMethod
end

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
  #
  # `.apply` is an alias for `.use` if you prefer.
  #
  # In cases where you have a scalar operation and want to map it over
  # an array/enumerable value in a pipeline you may use `.map_by`.
  #
  # class CleanUp < Pipeline::Base
  #   # The next two lines are equivalent:
  #   map_by Strip
  #   use ->(arr) { arr.map { |e| Strip.call(e) } }
  # end

  # rubocop:disable ThreadSafety/InstanceVariableInClassMethod
  class Base
    attr_reader :operations

    class << self
      def use(operation)
        @operations ||= []
        @operations << operation
      end

      alias apply use

      def map_by(operation)
        use ->(array) { array.map { |element| operation.call(element) } }
      end

      def call(arg)
        @operations.inject(arg) do |result, operation|
          operation.call(result)
        end
      end
    end
  end
  # rubocop:enable ThreadSafety/InstanceVariableInClassMethod
end

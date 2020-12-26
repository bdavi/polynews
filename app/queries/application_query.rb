# frozen_string_literal: true

# Abstract class which is parent of other queries
class ApplicationQuery
  class << self
    delegate :call, to: :new
  end

  # Implement this in derived classes
  # First positional param should be relations = <some activerecord class>.all
  # Recommend using keyword args for all additional arguments
  def call
    raise NotImplementedError
  end
end

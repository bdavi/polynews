# frozen_string_literal: true

module SpecHelpers
  def build_stubbed_list(name, amount, *traits, **overrides)
    Array.new(amount).map do
      FactoryBot.build_stubbed(name, *traits, overrides)
    end
  end
end

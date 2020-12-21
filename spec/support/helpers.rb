# frozen_string_literal: true

module SpecHelpers
  def build_stubbed_list(name, amount, *traits, **overrides)
    Array.new(amount).map do
      FactoryBot.build_stubbed(name, *traits, overrides)
    end
  end

  def described_module
    return described_class if described_class.is_a? Module

    nil
  end
end

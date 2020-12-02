# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  it :aggregate_failures do
    is_expected.to belong_to(:category).optional(true)
    is_expected.to have_many(:articles).dependent(:restrict_with_error)
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  it :aggregate_failures do
    is_expected.to validate_presence_of :slug
    is_expected.to validate_presence_of :sort_order
    is_expected.to validate_presence_of :title

    is_expected.to have_many(:channels).dependent(:restrict_with_error)
    is_expected.to have_many(:groups).dependent(:restrict_with_error)
    is_expected.to have_many(:articles).through(:channels).dependent(:restrict_with_error)
  end

  describe 'uniqueness' do
    subject(:category) { build(:category) }

    it :aggregate_failures do
      is_expected.to validate_uniqueness_of :slug
      is_expected.to validate_uniqueness_of :sort_order
      is_expected.to validate_uniqueness_of :title
    end
  end
end

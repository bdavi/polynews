# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Channel, type: :model do
  subject(:channel) { described_class.new }

  it :aggregate_failures do
    is_expected.to validate_presence_of :title
    is_expected.to validate_presence_of :url
    is_expected.to validate_url_format_of :url
  end

  describe 'url uniqueness' do
    subject(:channel) { build(:channel) }

    it { is_expected.to validate_uniqueness_of :url }
  end
end

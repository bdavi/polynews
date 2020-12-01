# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Channel, type: :model do
  subject(:channel) { described_class.new }

  it :aggregate_failures do
    is_expected.to validate_url_format_of(:image_url).allow_blank
    is_expected.to validate_presence_of :title
    is_expected.to validate_presence_of :url
    is_expected.to validate_url_format_of :url

    is_expected.to belong_to(:category).optional(true)
    is_expected.to have_many(:articles).dependent(:destroy)
  end

  it 'defaults use_scraper to false' do
    channel = described_class.new

    expect(channel.use_scraper).to be false
  end

  describe 'url uniqueness' do
    subject(:channel) { build(:channel) }

    it { is_expected.to validate_uniqueness_of :url }
  end
end

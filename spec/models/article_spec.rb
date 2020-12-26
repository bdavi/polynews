# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  subject(:article) { described_class.new }

  it :aggregate_failures do
    is_expected.to validate_presence_of(:channel).with_message('must exist')
    is_expected.to validate_presence_of :title
    is_expected.to validate_presence_of :url

    is_expected.to validate_url_format_of(:primary_image_url).allow_blank
    is_expected.to validate_url_format_of(:thumbnail_image_url).allow_blank
    is_expected.to validate_url_format_of :url

    is_expected.to belong_to :channel
    is_expected.to belong_to(:group).optional(true)
  end

  describe 'guid uniqueness' do
    subject(:article) { build(:article) }

    it { is_expected.to validate_uniqueness_of(:guid).scoped_to(:channel_id) }
  end

  describe 'scopes' do
    describe '.uses_scraper' do
      it 'returns the articles for channels that use the web scraper' do
        included = create(:article, :uses_scraper)
        create(:article, :does_not_use_scraper)

        expect(described_class.uses_scraper).to eq [included]
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  subject(:article) { described_class.new }

  it :aggregate_failures do
    is_expected.to validate_presence_of(:channel).with_message('must exist')
    is_expected.to validate_presence_of :title
    is_expected.to validate_presence_of :url

    is_expected.to validate_url_format_of(:image_url).allow_blank
    is_expected.to validate_url_format_of :url

    is_expected.to belong_to :channel
    is_expected.to belong_to(:group).optional(true)
  end

  describe 'guid uniqueness' do
    subject(:article) { build(:article) }

    it { is_expected.to validate_uniqueness_of(:guid).scoped_to(:channel_id) }
  end

  describe 'category validation' do
    context 'when the group and channel category do not match' do
      it 'is invalid' do
        channel = build_stubbed(:channel, :with_category)
        group = build_stubbed(:group, :with_category)
        article = build_stubbed(:article, channel: channel, group: group)

        article.valid?

        expect(article.errors[:group]).to include \
          'The channel category must match the group category'
      end
    end
  end

  describe '#processing_text' do
    context 'when the channel uses scraping' do
      it 'returns a string with the title and scraped_content' do
        channel = build_stubbed(:channel, use_scraper: true)
        article = described_class.new(title: 'abc', scraped_content: '123', channel: channel)

        expect(article.processing_text).to eq 'abc 123'
      end
    end

    context 'when the channel does not use scraping' do
      it 'returns a string with the title and feed content' do
        channel = build_stubbed(:channel, use_scraper: false)
        article = described_class.new(title: 'abc', content: '123', channel: channel)

        expect(article.processing_text).to eq 'abc 123'
      end
    end
  end

  describe 'ActiveRecord_Relation#clear_processing_cache!' do
    it 'sets the records processing_cache to nil' do
      create_list(:article, 3, processing_cache: { abc: '123' })
      articles = described_class.all

      described_class.all.clear_processing_cache!

      expect(articles.pluck(:processing_cache)).to eq [nil, nil, nil]
    end
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

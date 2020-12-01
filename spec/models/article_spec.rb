# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  subject(:article) { described_class.new }

  it :aggregate_failures do
    is_expected.to validate_presence_of(:channel).with_message('must exist')
    is_expected.to validate_url_format_of(:image_url).allow_blank
    is_expected.to validate_presence_of :title
    is_expected.to validate_presence_of :url
    is_expected.to validate_url_format_of :url
  end

  describe 'guid uniqueness' do
    subject(:article) { build(:article) }

    it { is_expected.to validate_uniqueness_of :guid }
  end

  describe '#processing_text' do
    it 'returns a string with the title and scraped_content' do
      article = described_class.new(title: 'abc', scraped_content: '123')

      expect(article.processing_text).to eq 'abc 123'
    end
  end
end

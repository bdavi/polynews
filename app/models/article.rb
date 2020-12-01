# frozen_string_literal: true

# == Schema Information
#
# Table name: articles
#
#  id               :bigint           not null, primary key
#  content          :text
#  description      :text
#  guid             :string           not null
#  image_alt        :string
#  image_url        :string
#  processing_cache :jsonb
#  published_at     :datetime
#  scraped_content  :text
#  title            :string           not null
#  url              :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  channel_id       :bigint           not null
#
# Indexes
#
#  index_articles_on_channel_id  (channel_id)
#  index_articles_on_guid        (guid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_64fe6f9351  (channel_id => channels.id)
#
class Article < ApplicationRecord
  delegate :use_scraper, to: :channel

  belongs_to :channel

  validates :guid, presence: true, uniqueness: true

  validates :image_url, url: { allow_blank: true }

  validates :title, presence: true

  validates :url, presence: true, url: true

  paginates_per 5

  def processing_text
    if use_scraper
      "#{title} #{scraped_content}"
    else
      "#{title} #{content}"
    end
  end
end

# frozen_string_literal: true

# == Schema Information
#
# Table name: articles
#
#  id                  :bigint           not null, primary key
#  content             :text
#  description         :text
#  guid                :string           not null
#  primary_image_url   :string
#  published_at        :datetime
#  scraped_content     :text
#  thumbnail_image_url :string
#  title               :string           not null
#  url                 :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  channel_id          :bigint           not null
#  group_id            :bigint
#
# Indexes
#
#  index_articles_on_channel_id           (channel_id)
#  index_articles_on_group_id             (group_id)
#  index_articles_on_guid_and_channel_id  (guid,channel_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_64fe6f9351  (channel_id => channels.id)
#  fk_rails_664112e3d7  (group_id => groups.id)
#
class Article < ApplicationRecord
  delegate :use_scraper, to: :channel

  belongs_to :channel

  belongs_to :group, optional: true

  validates :guid, presence: true, uniqueness: { scope: :channel_id }

  validates :primary_image_url, url: { allow_blank: true }

  validates :thumbnail_image_url, url: { allow_blank: true }

  validates :title, presence: true

  validates :url, presence: true, url: true

  paginates_per 5

  scope :uses_scraper, -> { joins(:channel).where(channels: { use_scraper: true }) }

  def self.pluck_processing_data # rubocop:disable Metrics/MethodLength
    pluck(
      :id,
      Arel.sql(
        "concat_ws(
            ' ',
            articles.title,
            articles.description,
            articles.content,
            articles.scraped_content
        )"
      ),
      :group_id
    )
  end
end

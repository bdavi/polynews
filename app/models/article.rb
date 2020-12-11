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
#  group_id         :bigint
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

  validates :image_url, url: { allow_blank: true }

  validates :title, presence: true

  validates :url, presence: true, url: true

  validate :validate_group_category_matches_channel_category

  paginates_per 5

  scope :uses_scraper, -> { joins(:channel).where(channels: { use_scraper: true }) }

  def processing_text
    if use_scraper
      "#{title} #{scraped_content}"
    else
      "#{title} #{content}"
    end
  end

  def validate_group_category_matches_channel_category
    return unless group && channel
    return if group.category == channel.category

    errors.add(:group, 'The channel category must match the group category')
  end

  class ActiveRecord_Relation # rubocop:disable Naming/ClassAndModuleCamelCase
    def clear_processing_cache!
      update_all(processing_cache: nil) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end

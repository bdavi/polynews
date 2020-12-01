# frozen_string_literal: true

# == Schema Information
#
# Table name: channels
#
#  id                        :bigint           not null, primary key
#  description               :text
#  image_url                 :string
#  last_build_date           :datetime
#  scraping_content_selector :string
#  title                     :string           not null
#  url                       :string           not null
#  use_scraper               :boolean          default(FALSE), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  category_id               :bigint
#
# Indexes
#
#  index_channels_on_category_id  (category_id)
#  index_channels_on_url          (url) UNIQUE
#
# Foreign Keys
#
#  fk_rails_c017bf7b32  (category_id => categories.id)
#
class Channel < ApplicationRecord
  validates :image_url, url: { allow_blank: true }

  validates :title, presence: true

  validates :url, presence: true, url: true, uniqueness: true

  has_many :articles, dependent: :destroy

  belongs_to :category, optional: true

  paginates_per 5
end

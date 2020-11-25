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
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_channels_on_url  (url) UNIQUE
#
class Channel < ApplicationRecord
  validates :image_url, url: { allow_blank: true }

  validates :title, presence: true

  validates :url, presence: true, url: true, uniqueness: true

  has_many :articles, dependent: :destroy

  paginates_per 5
end

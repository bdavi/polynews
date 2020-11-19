# frozen_string_literal: true

# == Schema Information
#
# Table name: channels
#
#  id              :bigint           not null, primary key
#  description     :text
#  last_build_date :datetime
#  title           :string           not null
#  url             :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_channels_on_url  (url) UNIQUE
#
class Channel < ApplicationRecord
  validates :title, presence: true

  validates :url, presence: true, url: true, uniqueness: true

  paginates_per 5
end

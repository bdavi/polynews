# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  slug       :string           not null
#  sort_order :integer          not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_slug        (slug) UNIQUE
#  index_categories_on_sort_order  (sort_order) UNIQUE
#  index_categories_on_title       (title) UNIQUE
#
class Category < ApplicationRecord
  validates :slug, presence: true, uniqueness: true

  validates :sort_order, presence: true, uniqueness: true

  validates :title, presence: true, uniqueness: true

  has_many :channels, dependent: :restrict_with_error

  has_many :groups, dependent: :restrict_with_error

  has_many :articles, through: :channels, dependent: :restrict_with_error

  paginates_per 5
end

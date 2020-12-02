# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#
# Indexes
#
#  index_groups_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_a61500b09c  (category_id => categories.id)
#
class Group < ApplicationRecord
  belongs_to :category, optional: true

  has_many :articles, dependent: :restrict_with_error

  paginates_per 10
end

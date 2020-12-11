# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id                               :bigint           not null, primary key
#  cached_article_count             :integer          default(0), not null
#  cached_article_last_published_at :datetime
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  category_id                      :bigint
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

  class ActiveRecord_Relation # rubocop:disable Naming/ClassAndModuleCamelCase
    def update_cached_attributes!
      update_all(  # rubocop:disable Rails/SkipsModelValidations
        <<-SQL.squish
          cached_article_count = (
            SELECT COUNT(*) FROM articles a WHERE a.group_id = groups.id
          ),
          cached_article_last_published_at = (
            SELECT MAX(published_at) FROM articles a WHERE a.group_id = groups.id
          )
        SQL
      )
    end
  end
end

# frozen_string_literal: true

module Groups
  # Queries for most recent Links
  class MinimizedQuery < ApplicationQuery
    def call(relation = Group.all)
      relation.where(cached_article_count: 1)
        .or(relation.where(cached_has_primary_image: false))
    end
  end
end

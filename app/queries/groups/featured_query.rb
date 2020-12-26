# frozen_string_literal: true

module Groups
  # Queries for most recent Links
  class FeaturedQuery < ApplicationQuery
    def call(relation = Group.all)
      relation
        .where('cached_article_count >= ?', 3)
        .where(cached_has_primary_image: true)
    end
  end
end

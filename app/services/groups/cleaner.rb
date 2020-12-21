# frozen_string_literal: true

require 'open-uri'

module Groups
  class Cleaner
    attr_reader :clean_before

    def initialize(clean_before = 2.days.ago)
      @clean_before = clean_before
    end

    def call
      clean_articles
      clean_groups
      Group.all.update_cached_attributes!
    end

    private

    def clean_articles
      Article.where(
        'published_at < ? OR group_id IS NULL', clean_before
      ).delete_all
    end

    def clean_groups
      Group.where.not(
        id: Article.where.not(id: nil).select(:group_id)
      ).delete_all
    end
  end
end

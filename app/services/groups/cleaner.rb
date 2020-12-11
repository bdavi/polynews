# frozen_string_literal: true

require 'open-uri'

module Groups
  class Cleaner < ApplicationService
    attr_reader :clean_before

    def initialize(clean_before = DateTime.now - 24.hours)
      @clean_before = clean_before
    end

    def call
      clean_articles
      clean_groups
      Group.all.update_cached_attributes!

      success(:cleaning_completed)
    end

    private

    def clean_articles
      Article.where('published_at < ?', clean_before).delete_all
      Article.where(group_id: nil).delete_all
    end

    def clean_groups
      Group.where.not(
        id: Article.where.not(id: nil).select(:group_id)
      ).delete_all
    end
  end
end

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
      Group.update_cached_attributes

      success(:cleaning_completed)
    end

    private

    def clean_articles
      Article.where('published_at < ?', clean_before).destroy_all
      Article.where(group_id: nil).destroy_all
    end

    def clean_groups
      Group.where.not(
        id: Article.where.not(id: nil).select(:group_id)
      ).destroy_all
    end
  end
end

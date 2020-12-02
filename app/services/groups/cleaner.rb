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

      success(:cleaning_completed)
    rescue StandardError => e
      failure(e)
    end

    private

    def clean_articles
      Article.where('published_at < ?', clean_before).destroy_all
    end

    def clean_groups
      Group.where.not(
        id: Article.select(:group_id)
      ).destroy_all
    end
  end
end

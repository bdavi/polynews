# frozen_string_literal: true

require 'open-uri'
require 'action_view'

module Channels
  class FeedSynchronizer < ApplicationService
    include ActionView::Helpers::SanitizeHelper

    attr_reader :channel, :feed

    delegate :last_build_date, to: :channel

    def initialize(channel)
      @channel = channel
    end

    def call
      download_feed

      return success(:no_update_required) unless requires_update?

      update_channel
      create_or_update_articles
    rescue StandardError => e
      failure(e)
    else
      success(:update_completed)
    end

    def download_feed
      @feed = Feedjira.parse(
        URI.parse(channel.url).read
      )
    end

    def requires_update?
      return true unless last_build_date

      last_build_date < feed.last_built
    end

    def update_channel
      channel.update(
        last_build_date: feed.last_built,
        image_url: feed.image&.url
      )
    end

    def create_or_update_articles
      feed.entries.each do |item|
        article = Article.find_or_initialize_by(guid: item.entry_id)
        update_article_from_item(article, item)
      end
    end

    private

    def update_article_from_item(article, item)
      article.update(
        channel: channel,
        title: item.title,
        description: item.summary,
        published_at: item.published,
        content: item.content,
        url: item.url,
        image_url: image_url(item),
        image_alt: image_alt(item)
      )
    end

    def image_url(item)
      url = item.image || first_image_url(item)

      return nil unless url
      return nil if url.include?('pixel')

      url
    end

    def image_alt(item)
      return nil if item.image

      first_image_attr(item.content, 'alt')
    end

    def first_image_url(item)
      first_image_attr(item.content, 'src')
    end

    def first_image_attr(content, attribute_name)
      first_image(content)&.attributes&.fetch(attribute_name, nil)&.value
    end

    def first_image(content)
      Nokogiri::HTML(content).css('img').first
    end
  end
end

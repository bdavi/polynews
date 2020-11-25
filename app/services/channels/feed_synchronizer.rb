# frozen_string_literal: true

require 'rss'
require 'open-uri'
require 'action_view'

# Channel related code
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
      @feed = RSS::Parser.parse(
        URI.parse(channel.url).read
      )
    end

    def requires_update?
      return true unless last_build_date

      last_build_date < feed.channel.lastBuildDate
    end

    def update_channel
      channel.update(
        last_build_date: feed.channel.lastBuildDate,
        image_url: feed.channel&.image&.url
      )
    end

    def create_or_update_articles
      feed.items.each do |item|
        article = Article.find_or_initialize_by(guid: item.guid.content)
        update_article_from_item(article, item)
      end
    end

    private

    def update_article_from_item(article, item)
      article.update(
        channel: channel,
        title: item.title,
        description: item.description,
        published_at: item.pubDate,
        content: item.content_encoded,
        url: item.link,
        image_url: first_image_attr(item.content_encoded, 'src'),
        image_alt: first_image_attr(item.content_encoded, 'alt')
      )
    end

    def first_image_attr(content, attribute_name)
      first_image(content)&.attributes&.fetch(attribute_name, nil)&.value
    end

    def first_image(content)
      Nokogiri::HTML(content).css('img').first
    end
  end
end

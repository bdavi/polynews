# frozen_string_literal: true

require 'open-uri'

module Channels
  class FeedDownloader
    attr_reader :channel, :feed, :invalid_entry_count, :discard_articles_before,
                :allowed_invalid_entry_percent

    def initialize(
      channel,
      allowed_invalid_entry_percent: 0.1,
      discard_articles_before: 2.days.ago
    )
      @channel = channel
      @invalid_entry_count = 0
      @allowed_invalid_entry_percent = allowed_invalid_entry_percent
      @discard_articles_before = discard_articles_before
    end

    def call
      download_feed
      return unless requires_update?

      update_channel
      create_or_update_articles
    end

    def download_feed
      @feed = RSS::Parser.parse(
        URI.parse(channel.url).read
      )
    end

    def requires_update?
      return true unless feed_includes_last_built? && channel.last_build_date

      channel.last_build_date < feed.last_built
    end

    def update_channel
      return unless feed_includes_last_built?

      channel.update!(last_build_date: feed.last_built)
    end

    def create_or_update_articles
      feed.entries.each do |entry|
        next unless entry_creatable?(entry)

        article = Article.find_or_initialize_by(guid: guid(entry), channel: channel)
        next if article.persisted?

        create_article_from_entry(article, entry)
      end
    end

    private

    def create_article_from_entry(article, entry)
      article.update!(entry.article_attributes)
    rescue StandardError => e # rubocop:disable Lint/UselessAssignment
      handle_article_creation_error(entry)
    end

    def handle_article_creation_error(entry)
      # These feeds sometimes have invalid data (like malformed urls for an
      # entry) that prevent processing.
      #
      # For our purposes it's ok to drop a few articles so long as the
      # balance of the feed is behaving itself.
      #
      # Continue processing the feed and ignore up to the specified threshold.
      @invalid_entry_count += 1
      return unless invalid_entry_count > max_allowed_invalid_entries

      raise ExceededMaxInvalidEntryCount, \
            "Channel: #{channel.id} is invalid. Entry: #{entry.inspect}"
    end

    def max_allowed_invalid_entries
      allowed_invalid_entry_percent * feed.entries.count.to_f
    end

    # The parser doesn't always define `last_built`. Check before using.
    def feed_includes_last_built?
      feed.respond_to?(:last_built)
    end

    # The parser doesn't always have a value for `entry_id`. Substitute url when missing.
    def guid(entry)
      entry.entry_id || entry.url
    end

    # Publication date must be present and before cutoff.
    def entry_creatable?(entry)
      entry.published_at && discard_articles_before < entry.published_at
    end

    class ExceededMaxInvalidEntryCount < StandardError; end
  end
end

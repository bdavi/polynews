# frozen_string_literal: true

namespace :news do
  desc 'Downloads the feed and updates the db with current news'
  task update: :environment do
    discard_before = 2.days.ago

    Groups::Cleaner.new(discard_before).call

    Category.find_each do |category|
      category.channels.find_each do |channel|
        Channels::FeedSynchronizer.new(
          channel,
          allowed_invalid_entry_percent: 0.2,
          discard_articles_before: discard_before
        ).call
      end

      category.articles.find_each do |article|
        Articles::ContentScraper.new(article).call
      end

      Groups::Creator.new(category).call
    end

    puts 'Success'
  end

  desc 'Clears the db of news related records'
  task clear_all: :environment do
    Article.delete_all
    Group.delete_all
    Channel.delete_all
    Category.delete_all
  end

  desc 'Clears, seeds, downloads and groups the news'
  task full_refresh: %i[environment clear_all db:seed update_news]
end

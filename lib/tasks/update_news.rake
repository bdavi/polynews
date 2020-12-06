# frozen_string_literal: true

desc 'Updates the db with current news'
task update_news: :environment do
  Groups::Cleaner.new(DateTime.now - 3.days).call

  Category.find_each do |category|
    category.channels.find_each do |channel|
      Channels::FeedSynchronizer.new(channel).call
    end

    category.articles.find_each do |article|
      Articles::ContentScraper.new(article).call
    end

    Groups::Creator.new(
      articles: category.articles,
      groups: category.groups
    ).call
  end

  Groups::Cleaner.new(DateTime.now - 7.days).call

  puts 'Success'
end

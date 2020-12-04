# frozen_string_literal: true

desc 'Updates the db with current news'
task update_news: :environment do
  Groups::Cleaner.new.call
  Channel.find_each { |channel| Channels::FeedSynchronizer.new(channel).call }
  Article.find_each { |article| Articles::ContentScraper.new(article).call }
  Category.find_each do |category|
    Groups::Creator.new(articles: category.articles, groups: category.groups).call
  end
  puts 'Success'
end

# frozen_string_literal: true

namespace :news do
  desc 'Downloads the feed and updates the db with current news'
  task update: :environment do
    discard_before = 2.days.ago
    creator = Groups::Creator.new

    Groups::Cleaner.new(discard_before).call
    Category.find_each do |category|
      category.channels.find_each do |channel|
        Channels::FeedDownloader.new(
          channel,
          allowed_invalid_entry_percent: 0.2,
          discard_articles_before: discard_before
        ).call
      end
      category.articles.uses_scraper.find_each do |article|
        Articles::ContentScraper.new(article).call
      end
      creator.call(articles: category.articles, groups: category.groups)
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
  task full_refresh: %i[environment news:clear_all db:seed news:update]

  desc 'Destroys all groups and rebuilds them, but does not refresh from the rss feeds'
  task regroup: :environment do
    Article.update_all(group_id: nil) # rubocop:disable Rails/SkipsModelValidations
    Group.delete_all
    creator = Groups::Creator.new
    Category.find_each do |category|
      creator.call(articles: category.articles, groups: category.groups)
    end
  end

  namespace :print do
    desc 'Prints groups to console for debugging'
    task groups: :environment do
      puts '###################################################################'
      puts "Total Groups: #{Group.count}"
      Group.distinct.pluck(:cached_article_count).sort.reverse_each do |count|
        puts "   With #{count} articles: #{Group.where('cached_article_count = ?', count).size}"
      end
      puts "Total Articles: #{Article.count}"
      puts '###################################################################'

      Category.all.each do |category|
        puts "\n###################################################################"
        groups = category.groups.includes(articles: :channel).order(cached_article_count: :desc)
        puts "Category: #{category.title}"
        puts "Groups: #{groups.count}"
        article_counts = groups.distinct.pluck(:cached_article_count).sort.reverse
        article_counts.each do |count|
          puts "   With #{count} articles: #{groups.where('cached_article_count = ?', count).size}"
        end
        puts "Articles: #{category.articles.count}"
        puts "###################################################################\n"

        groups.each do |group|
          group.articles.each do |article|
            puts "#{article.id} / #{article.channel.id}   #{article.title} " \
                   "(#{article.channel.decorate.display_title})"
          end
          puts '-------------------------------------------------------------------'
        end
      end
    end
  end
end

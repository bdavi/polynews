# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

require 'open-uri'

module Groups
  class Creator < ApplicationService
    attr_reader :model, :max_angle_between_articles, :category

    def initialize(category, max_angle_between_articles: 1.3)
      @category = category
      @max_angle_between_articles = max_angle_between_articles
    end

    def call
      build_bow_model
      create_and_cache_article_vectors
      group_articles_by_vector_angle
      groups.update_cached_attributes!
      articles.clear_processing_cache!

      success(:groups_created)
    end

    private

    def build_bow_model
      @model = NLP::BOW::Model.new

      articles.find_each do |article|
        model.add_document(article.processing_text)
      end
    end

    def create_and_cache_article_vectors
      articles.find_each do |article|
        vector = model.vector_for(article.processing_text)
        article.update!(processing_cache: { vector: vector })
      end
    end

    def group_articles_by_vector_angle
      articles.where(group_id: nil).find_each do |article|
        join_or_create_group_for(article)
      end
    end

    def join_or_create_group_for(article)
      article_vector = _article_vector(article)

      groups.find_each do |group|
        group_vector = _article_vector(group.articles.first)
        angle = article_vector.angle_with(group_vector)

        next unless angle <= max_angle_between_articles

        article.update!(group: group)
        break
      end

      build_group_for(article) unless article.group
    end

    def _article_vector(article)
      Vector.elements(article.processing_cache['vector'], false)
    end

    def build_group_for(article)
      Group.create!(category_id: article.channel.category_id, articles: [article])
    end

    def groups
      Group
        .joins(articles: :channel)
        .includes(articles: :channel)
        .where(category: category)
        .select(
          :id,
          :'articles.id',
          :'articles.processing_cache',
          :'articles.title',
          :'articles.content',
          :'articles.scraped_content',
          :'channels.id',
          :'channels.use_scraper'
        )
    end

    def articles
      Article
        .joins(:channel)
        .includes(:channel)
        .where(channels: { category_id: category.id })
        .select(
          :id,
          :title,
          :content,
          :scraped_content,
          :'channels.id',
          :'channels.use_scraper'
        )
    end
  end
end
# rubocop:enable Metrics/MethodLength

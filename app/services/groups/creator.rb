# frozen_string_literal: true

require 'open-uri'

module Groups
  class Creator < ApplicationService
    attr_reader :model, :articles, :max_angle_between_articles, :groups

    def initialize(articles: Article.all, max_angle_between_articles: 1.3, groups: Group.all)
      @articles = articles
      @groups = groups
      @max_angle_between_articles = max_angle_between_articles
    end

    def call
      build_bow_model
      create_and_cache_article_vectors
      group_articles_by_vector_distance

      success(:groups_created)
    rescue StandardError => e
      failure(e)
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
        article.update(processing_cache: { vector: vector })
      end
    end

    def group_articles_by_vector_distance
      articles.where(group_id: nil).find_each do |article|
        join_or_create_group_for(article)
      end
    end

    def join_or_create_group_for(article)
      article_vector = _article_vector(article)

      groups.includes(:articles).find_each do |group|
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
      Group.create!(category: article.channel.category, articles: [article])
    end
  end
end

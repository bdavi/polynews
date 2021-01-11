# frozen_string_literal: true

module Groups
  class Creator
    attr_reader :model, :max_angle_between_articles, :article_vectors,
                :group_vectors, :article_data, :articles, :groups

    def call(articles:, groups:, max_angle_between_articles: 1.35)
      init(articles, groups, max_angle_between_articles)
      load_article_data
      build_bow_model
      cache_article_vectors
      group_articles_by_vector_angle
      update_cached_attributes_on_groups
    end

    private

    def init(articles, groups, max_angle_between_articles)
      @articles = article_relation(articles)
      @groups = group_relation(groups).to_a
      @max_angle_between_articles = max_angle_between_articles
      @article_vectors = {}
      @group_vectors = {}
    end

    def load_article_data
      @article_data = articles.pluck_processing_data
    end

    def build_bow_model
      @model = NLP::BOW::Model.new
      article_data.each { |_, text| model.add_document(text) }
    end

    def cache_article_vectors
      article_data.each do |id, text|
        article_vectors[id] = model.vector_for(text)
      end
    end

    def group_articles_by_vector_angle
      articles.where(group_id: nil).each do |article|
        join_or_create_group_for(article)
      end
    end

    def update_cached_attributes_on_groups
      Group.where(id: group_vectors.keys).update_cached_attributes!
    end

    def join_or_create_group_for(article)
      group = find_matching_group(article)

      if group
        add_article_to_group(article, group)
      else
        build_group_for(article)
      end
    end

    def find_matching_group(article)
      return nil if article_vectors[article.id].zero?

      groups.find { |group| article_matches_group(article, group) }
    end

    def article_matches_group(article, group)
      angle_between(article, group) <= max_angle_between_articles
    end

    def angle_between(article, group)
      article_vectors[article.id].angle_with(group_vector(group))
    end

    def add_article_to_group(article, group)
      group.articles << article
      refresh_group_vector(group)
    end

    def group_vector(group)
      refresh_group_vector(group) unless group_vectors[group.id]
      group_vectors[group.id]
    end

    def build_group_for(article)
      group = Group.create!(category: article.channel.category, articles: [article])
      groups << group
      refresh_group_vector(group)
    end

    def refresh_group_vector(group)
      group_vectors[group.id] = build_group_vector(group)
    end

    def build_group_vector(group)
      vectors = group.articles.map { |article| article_vectors[article.id] }
      NLP::FeatureMatrix[*vectors].average_vector
    end

    def group_relation(groups)
      groups
        .joins(articles: { channel: :category })
        .includes(articles: { channel: :category })
        .select(
          :id,
          :'articles.id',
          :'channels.id',
          :'channels.category_id',
          :'categories.id'
        )
    end

    def article_relation(articles)
      articles
        .joins(channel: :category)
        .includes(channel: :category)
        .select(
          :id,
          :'channels.id',
          :'channels.category_id',
          :'categories.id'
        )
    end
  end
end

# frozen_string_literal: true

class News
  attr_reader :params, :category

  def initialize(params)
    @params = params
    @category = Category.find_by(slug: category_slug) || NullCategory.new(category_slug)
  end

  def category_slug
    params[:category]
  end

  def groups
    category
      .groups
      .joins(:category)
      .includes(articles: :channel)
      .order(cached_article_last_published_at: :desc)
      .page(params[:page])
      .per(20)
  end

  class NullCategory
    attr_reader :slug

    def initialize(slug)
      @slug = slug
    end

    def title
      slug.titleize
    end

    def groups
      Group.where('cached_article_count > ?', 2)
    end
  end
end

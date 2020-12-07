# frozen_string_literal: true

class News
  attr_reader :params, :category

  def initialize(params)
    @params = params
  end

  def category_slug
    params[:category]
  end

  def category # rubocop:disable Lint/DuplicateMethods
    @category ||= Category.find_by(slug: category_slug)
  end

  def groups
    Group
      .where(category: category)
      .includes(articles: :channel)
      .order(cached_article_last_published_at: :desc)
      .page(params[:page])
      .per(20)
  end
end

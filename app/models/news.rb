# frozen_string_literal: true

class News
  attr_reader :params, :category, :featured, :emphasized, :minimized, :groups

  def initialize(params)
    @params = params
    @category = init_category
    @featured = group_relation(:featured, per: 2)
    @emphasized = group_relation(:emphasized, per: 4)
    @minimized = group_relation(:minimized, per: 8)
    @groups = (minimized.to_a + emphasized.to_a + featured.to_a).map(&:decorate)
  end

  def category_slug
    params[:category]
  end

  def group_relation(kind, per:)
    category
      .groups
      .send(kind)
      .joins(:category)
      .includes(articles: :channel)
      .order(cached_article_last_published_at: :desc)
      .page(params[:page])
      .per(per)
  end

  def init_category
    Category.find_by(slug: category_slug) || HeadlineCategory.new
  end

  class HeadlineCategory
    def title
      'Headlines'
    end

    def groups
      Group.where('cached_article_count > ?', 3)
    end
  end
end

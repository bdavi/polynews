# frozen_string_literal: true

class News
  attr_reader :params, :category, :featured, :emphasized, :minimized,
              :paging_collection

  def initialize(params)
    @params = params
    @category = init_category
    @paging_collection = group_relation(:minimized, per: 6)
    @featured = group_relation(:featured, per: 1).first&.decorate
    @emphasized = group_relation(:emphasized, per: 1).first&.decorate
    @minimized = paging_collection.to_a.map(&:decorate)
  end

  def category_slug
    params[:category]
  end

  def any_groups?
    featured || emphasized || minimized.any?
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

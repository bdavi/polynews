# frozen_string_literal: true

class GroupDecorator < Draper::Decorator
  delegate_all

  delegate :title, :channel_title, :published_at, :display_summary,
           :primary_image_url, :url, :thumbnail_image_url,
           to: :primary_article

  attr_reader :_articles

  def _articles # rubocop:disable Lint/DuplicateMethods
    @_articles = articles.order(published_at: :desc).decorate.to_a
  end

  def primary_article
    first_article_with_image || _articles.first
  end

  def first_article_with_image
    _articles.find(&:primary_image_url)
  end

  def secondary_articles
    _articles - [primary_article]
  end

  def image?
    primary_image_url.present?
  end

  def show_card_body?
    display_summary.present? || secondary_articles.any?
  end
end

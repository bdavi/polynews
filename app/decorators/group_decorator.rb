# frozen_string_literal: true

class GroupDecorator < Draper::Decorator
  delegate_all

  delegate :title, :channel_title, :display_summary, :image_url, to: :primary_article

  attr_reader :_articles

  def _articles # rubocop:disable Lint/DuplicateMethods
    @_articles = articles.order(published_at: :desc).decorate.to_a
  end

  def primary_article
    first_article_with_image || _articles.first
  end

  def first_article_with_image
    _articles.find(&:image_url)
  end

  def secondary_articles
    _articles - [primary_article]
  end

  def image?
    image_url.present?
  end

  def highlight?
    _articles.count > 1
  end

  def show_card_body?
    display_summary.present? || secondary_articles.any?
  end

  def card_classes
    classes = 'card mb-4'

    if highlight?
      "#{classes} bg-dark hightlight"
    else
      "#{classes} border-dark bg-light"
    end
  end
end

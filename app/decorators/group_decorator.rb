# frozen_string_literal: true

class GroupDecorator < Draper::Decorator
  delegate_all

  delegate :title, :channel_title, to: :primary_article

  def articles
    object.articles.decorate
  end

  def primary_article
    articles.first
  end

  def secondary_articles
    articles.drop(1)
  end

  def image_url
    articles.map(&:image_url).compact.first
  end

  def image?
    image_url.present?
  end

  def highlight?
    articles.count > 1
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

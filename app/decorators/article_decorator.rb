# frozen_string_literal: true

class ArticleDecorator < Draper::Decorator
  include ActionView::Helpers::SanitizeHelper

  SUMMARY_LENGTH = 300

  delegate_all

  def channel_title
    channel.decorate.display_title
  end

  def display_summary
    return nil unless description

    stripped = strip_tags(description)
    return stripped if stripped.length <= SUMMARY_LENGTH

    index_of_last_space_before_end = stripped.first(SUMMARY_LENGTH).rindex(' ')

    "#{stripped.first(index_of_last_space_before_end)}..."
  end
end

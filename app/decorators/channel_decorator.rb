# frozen_string_literal: true

class ChannelDecorator < Draper::Decorator
  delegate_all

  def display_title
    title.split('|').first.strip
  end
end

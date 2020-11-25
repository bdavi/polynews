# frozen_string_literal: true

module ApplicationHelper
  def coalesce(*values)
    values.reject(&:blank?).first
  end

  def empty_text
    '<em class="text-black-50">Empty</em>'.html_safe
  end

  def coalesce_to_empty(*values)
    coalesce(*(values + [empty_text]))
  end
end

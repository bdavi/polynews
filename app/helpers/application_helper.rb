# frozen_string_literal: true

require 'json'

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

  def pretty_format_json(json)
    JSON.pretty_generate(json)
  end

  def yes_no(boolean)
    boolean ? 'Yes' : 'No'
  end

  def page_n_of_m(collection)
    return '' if collection.empty?

    "Page #{collection.current_page} of #{collection.total_pages}"
  end
end

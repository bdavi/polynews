# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'channels/show', type: :view do
  it 'renders the associated articles' do
    channel = build(
      :channel,
      id: 1,
      articles: build_stubbed_list(:article, 2)
    )
    assign(:channel, channel)

    render

    channel.articles.each do |article|
      expect(rendered).to have_text article.title
      expect(rendered).to have_text article.description
    end
  end
end

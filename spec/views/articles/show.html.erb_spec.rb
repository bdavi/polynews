# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'articles/show', type: :view do
  context 'when there is content' do
    it 'displays the content' do
      article = build_stubbed(:article, content: 'abc123')
      assign(:article, article)

      render

      expect(rendered).to have_text article.content
    end
  end
end

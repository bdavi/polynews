# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User deletes article', type: :feature do
  scenario 'from the index' do
    article = create(:article)

    visit articles_path

    expect {
      click_on 'Delete'
    }.to change(Article, :count).by(-1)

    expect(page).to have_flash(:success, 'Successfully deleted article')
    expect(page).not_to have_text(article.title)
  end

  scenario 'from the detail' do
    article = create(:article)

    visit article_path(article)

    expect {
      click_on 'Delete'
    }.to change(Article, :count).by(-1)

    expect(page).to have_flash(:success, 'Successfully deleted article')
    expect(page).not_to have_text(article.title)
  end
end

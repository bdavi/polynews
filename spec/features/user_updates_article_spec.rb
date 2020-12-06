# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User updates article', type: :feature do
  scenario 'from articles index' do
    article = create(:article)
    original_title = article.title
    new_title = 'abc123'

    visit articles_path

    click_on 'Edit'

    fill_in 'Title', with: new_title
    click_on 'Update Article'
    article.reload

    expect(article.title).to eq new_title
    expect(page).to have_flash(:success, 'Successfully updated article')
    expect(page).to have_text(new_title)
    expect(page).not_to have_text(original_title)
  end

  scenario 'with invalid attributes' do
    article = create(:article)
    to_update = create(:article)

    visit edit_article_path(to_update)

    fill_in 'Guid', with: article.guid
    select article.channel.title, from: 'article_channel_id'
    click_on 'Update Article'

    expect(form_error_messages).to eq ['Guid has already been taken']
  end
end

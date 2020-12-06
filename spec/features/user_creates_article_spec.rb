# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User creates article', type: :feature do
  scenario 'from articles index' do
    channel = create(:channel)

    visit articles_path

    expect(page).to have_text('No articles to display.')

    click_on 'New Article'

    attrs = attributes_for(:article)
              .slice(*new_article_attributes)
              .merge(channel: channel.title)

    expect {
      fill_form_and_submit(:article, attrs)
    }.to change(Article, :count).by(1)

    attrs.each_value do |value|
      expect(page).to have_text value
    end

    expect(page).to have_flash(:success, 'Successfully created article')
  end

  scenario 'with invalid attributes' do
    article = create(:article)

    visit new_article_path

    fill_in('Description', with: 'Some Description')
    fill_in('Guid', with: article.guid)

    expect {
      click_on 'Create Article'
    }.not_to change(Article, :count)

    expect(form_error_messages).to eq [
      "Title can't be blank",
      "Url can't be blank and Url is an invalid URL",
      'Channel must exist'
    ]
  end

  def new_article_attributes
    %i[title description guid url]
  end
end

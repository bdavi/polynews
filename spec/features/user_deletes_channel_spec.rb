# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User deletes channel', type: :feature do
  scenario 'from the index' do
    channel = create(:channel)

    visit channels_path

    expect {
      click_on 'Delete'
    }.to change(Channel, :count).by(-1)

    expect(page).to have_flash(:success, 'Successfully deleted channel')
    expect(page).not_to have_text(channel.title)
  end

  scenario 'from the detail' do
    channel = create(:channel)

    visit channel_path(channel)

    expect {
      click_on 'Delete'
    }.to change(Channel, :count).by(-1)

    expect(page).to have_flash(:success, 'Successfully deleted channel')
    expect(page).not_to have_text(channel.title)
  end

  scenario 'with associated article' do
    channel = create(:channel, :with_articles, article_count: 2)

    visit channels_path

    expect {
      click_on 'Delete'
    }.to change(Channel, :count).by(-1).and change(Article, :count).by(-2)

    expect(page).to have_flash(:success, 'Successfully deleted channel')
    expect(page).not_to have_text(channel.title)
  end
end

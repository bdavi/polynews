# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User updates channel', type: :feature do
  scenario 'from channels index' do
    channel = create(:channel)
    original_title = channel.title
    new_title = 'abc123'

    visit channels_path

    click_on 'Edit'

    fill_in 'Title', with: new_title
    find(:css, '#channel_use_scraper').set(true)
    click_on 'Update Channel'
    channel.reload

    expect(channel.title).to eq new_title
    expect(channel.use_scraper).to be true
    expect(page).to have_flash(:success, 'Successfully updated channel')
    expect(page).to have_text(new_title)
    expect(page).not_to have_text(original_title)
  end

  scenario 'with invalid attributes' do
    channel = create(:channel)
    to_update = create(:channel)

    visit edit_channel_path(to_update)

    fill_in 'Url', with: channel.url
    click_on 'Update Channel'

    expect(form_error_messages).to eq ['Url has already been taken']
  end
end

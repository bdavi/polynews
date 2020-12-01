# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User creates channel', type: :feature do
  scenario 'from channels index' do
    visit channels_path

    expect(page).to have_text('No channels to display.')

    click_on 'New Channel'

    attrs = attributes_for(:channel).slice(*new_channel_attributes)
    expect {
      fill_form_and_submit(:channel, attrs)
    }.to change(Channel, :count).by(1)

    attrs.each_value do |value|
      expect(page).to have_text value
    end

    expect(page).to have_flash(:success, 'Successfully created channel')
  end

  scenario 'with invalid attributes' do
    channel = create(:channel)

    visit new_channel_path

    fill_in('Description', with: 'Some Description')
    fill_in('Url', with: channel.url)

    expect {
      click_on 'Create Channel'
    }.not_to change(Channel, :count)

    expect(form_error_messages).to eq ["Title can't be blank", 'Url has already been taken']
  end

  def new_channel_attributes
    %i[title description use_scraper url]
  end
end

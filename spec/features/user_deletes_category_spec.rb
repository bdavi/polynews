# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User deletes category', type: :feature do
  scenario 'from the index' do
    category = create(:category)

    visit categories_path

    expect {
      click_on 'Delete'
    }.to change(Category, :count).by(-1)

    expect(page).to have_flash(:success, 'Successfully deleted category')
    expect(page).not_to have_text(category.title)
  end

  scenario 'from the detail' do
    category = create(:category)

    visit category_path(category)

    expect {
      click_on 'Delete'
    }.to change(Category, :count).by(-1)

    expect(page).to have_flash(:success, 'Successfully deleted category')
    expect(page).not_to have_text(category.title)
  end

  scenario 'with associated channel' do
    category = create(:category, :with_channels, channel_count: 2)

    visit categories_path

    expect {
      click_on 'Delete'
    }.not_to change(Category, :count)

    expect(page).to have_flash(
      :error, 'Could not delete category. Please veify there are no channels.'
    )
    expect(page).to have_text(category.title)
  end
end

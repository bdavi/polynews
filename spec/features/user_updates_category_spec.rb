# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User updates category', type: :feature do
  scenario 'from categories index' do
    category = create(:category)
    original_title = category.title
    new_title = 'abc123'

    visit categories_path

    click_on 'Edit'

    fill_in 'Title', with: new_title
    click_on 'Update Category'
    category.reload

    expect(category.title).to eq new_title
    expect(page).to have_flash(:success, 'Successfully updated category')
    expect(page).to have_text(new_title)
    expect(page).not_to have_text(original_title)
  end

  scenario 'with invalid attributes' do
    category = create(:category)
    to_update = create(:category)

    visit edit_category_path(to_update)

    fill_in 'Title', with: category.title
    click_on 'Update Category'

    expect(form_error_messages).to eq ['Title has already been taken']
  end
end

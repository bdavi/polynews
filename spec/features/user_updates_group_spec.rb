# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User updates group', type: :feature do
  scenario 'from groups index' do
    original_category = create(:category)
    new_category = create(:category)
    group = create(:group, category: original_category)

    visit groups_path

    click_on 'Edit'

    fill_form_and_submit(:group, :edit, { category_id: new_category.title })

    group.reload

    expect(group.category).to eq new_category
    expect(page).to have_flash(:success, 'Successfully updated group')
    expect(page).to have_text(new_category.title)
    expect(page).not_to have_text(original_category.title)
  end
end

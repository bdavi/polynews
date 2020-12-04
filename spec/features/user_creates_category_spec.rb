# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User creates category', type: :feature do
  scenario 'from categories index' do
    visit categories_path

    expect(page).to have_text('No categories to display.')

    click_on 'New Category'

    attrs = attributes_for(:category).slice(*new_category_attributes)
    expect {
      fill_form_and_submit(:category, attrs)
    }.to change(Category, :count).by(1)

    attrs.each_value do |value|
      expect(page).to have_text value
    end

    expect(page).to have_flash(:success, 'Successfully created category')
  end

  scenario 'with invalid attributes' do
    category = create(:category)

    visit new_category_path

    fill_in('Title', with: category.title)

    expect {
      click_on 'Create Category'
    }.not_to change(Category, :count)

    expect(form_error_messages).to eq \
      ['Title has already been taken', "Slug can't be blank", "Sort order can't be blank"]
  end

  def new_category_attributes
    %i[title sort_order slug]
  end
end

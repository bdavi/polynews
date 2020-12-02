# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User creates group', type: :feature do
  scenario 'from groups index' do
    visit groups_path

    expect(page).to have_text('No groups to display.')

    click_on 'New Group'

    attrs = attributes_for(:group, :with_category).slice(*new_group_attributes)
    expect {
      fill_form_and_submit(:group, attrs)
    }.to change(Group, :count).by(1)

    attrs.each_value do |value|
      expect(page).to have_text value
    end

    expect(page).to have_flash(:success, 'Successfully created group')
  end

  def new_group_attributes
    [:category_id]
  end
end

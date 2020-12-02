# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User deletes group', type: :feature do
  scenario 'from the index' do
    group = create(:group)

    visit groups_path

    expect {
      click_on 'Delete'
    }.to change(Group, :count).by(-1)

    expect(page).to have_flash(:success, 'Successfully deleted group')
    expect(page).not_to have_text(group.id)
  end

  scenario 'from the detail' do
    group = create(:group)

    visit group_path(group)

    expect {
      click_on 'Delete'
    }.to change(Group, :count).by(-1)

    expect(page).to have_flash(:success, 'Successfully deleted group')
    expect(page).not_to have_text(group.id)
  end

  scenario 'with associated articles' do
    group = create(:group, :with_articles, article_count: 2)

    visit groups_path

    expect {
      click_on 'Delete'
    }.not_to change(Group, :count)

    expect(page).to have_flash(
      :error, 'Could not delete group. Please veify there are no articles.'
    )
    expect(page).to have_text(group.id)
  end
end

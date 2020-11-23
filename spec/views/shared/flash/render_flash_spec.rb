# frozen_string_literal: true

require 'rails_helper'

describe 'rendering the flash', type: :view do
  let(:flash) do
    {
      'alert' => 'Check yourself before you wreck yourself',
      'notice' => ['You should know this.', 'and this!'],
      'do_not_display' => 'should_not_be_rendered'
    }
  end

  def render_flash
    render partial: 'shared/flash/group', locals: { flash: flash }
  end

  it 'shows the displayable messages' do
    render_flash

    expect(rendered).to have_text 'Check yourself'
  end

  it 'renders the correct alert class' do
    render_flash

    expect(rendered).to have_css '.flash.alert-warning'
  end

  it 'does not show non-displayable flash keys' do
    render_flash

    expect(rendered).not_to have_text 'should_not_be_rendered'
  end

  it 'renders two messages when the key is an array' do
    render_flash

    expect(rendered).to have_text 'You should'
    expect(rendered).to have_text 'and this'
  end
end

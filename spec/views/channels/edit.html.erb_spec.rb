# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'channels/edit', type: :view do
  it 'renders the edit channel form' do
    @channel = build_stubbed(:channel)

    render

    assert_select 'form[action=?][method=?]', channel_path(@channel), 'post' do
      assert_select 'input[name=?]', 'channel[title]'
      assert_select 'input[name=?]', 'channel[url]'
      assert_select 'textarea[name=?]', 'channel[description]'
    end
  end
end

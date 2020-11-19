# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'channels/new', type: :view do
  it 'renders new channel form' do
    @channel = Channel.new

    render

    assert_select 'form[action=?][method=?]', channels_path, 'post' do
      assert_select 'input[name=?]', 'channel[title]'
      assert_select 'input[name=?]', 'channel[url]'
      assert_select 'textarea[name=?]', 'channel[description]'
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'channels/index', type: :view do
  it 'renders a list of channels' do
    @channels = [create(:channel), create(:channel)]

    render

    @channels.each do |channel|
      assert_select 'tr>td', text: channel.title
    end
  end
end

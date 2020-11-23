# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'channels/_channel', type: :view do
  context 'when last_build_date is present' do
    it "displays a 'time ago' time tag" do
      datetime = DateTime.new(2001, 2, 3, 4, 5, 6)
      channel = build_stubbed(:channel, last_build_date: datetime - 1.hour)

      Timecop.freeze(datetime) do
        render partial: 'channels/channel', locals: { channel: channel }
      end

      expect(rendered).to have_css '[data-local="time-ago"]'
      expect(rendered).to have_text 'February  3, 2001  3:05am'
    end
  end

  context 'when last_build_date is nil' do
    it "displays 'Never'" do
      channel = build_stubbed(:channel, last_build_date: nil)

      render partial: 'channels/channel', locals: { channel: channel }

      expect(rendered).to have_text(/Never/)
    end
  end
end

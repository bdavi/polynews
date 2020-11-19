# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'channels/index', type: :view do
  context 'when there are channels to display' do
    it 'renders a list of channels' do
      @channels = Kaminari.paginate_array(
        [build_stubbed(:channel), build_stubbed(:channel)]
      ).page(1)

      render

      @channels.each do |channel|
        expect(rendered).to match(/#{channel.title}/)
      end
    end
  end

  context 'when there are no channels' do
    it "displays a 'no channels' message" do
      @channels = Kaminari.paginate_array([]).page(1)

      render

      expect(rendered).to match(/No channels/)
    end
  end
end

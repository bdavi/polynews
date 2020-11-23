# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'channels/index', type: :view do
  context 'when there are no channels' do
    it "displays a 'no channels' message" do
      assign(:channels, Kaminari.paginate_array([]).page(1))

      render

      expect(rendered).to have_text 'No channels'
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'channels/show', type: :view do
  it 'renders attributes in <p>' do
    @channel = create(:channel)

    render

    expect(rendered).to match(/#{@channel.title}/)
    expect(rendered).to match(/#{@channel.url}/)
    expect(rendered).to match(/#{@channel.description}/)
  end
end

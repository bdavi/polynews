# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSS::EntryParser do
  describe '#primary_image_url' do
    it 'returns media_content_url when valid url' do
      url = 'http://www.example.com/abc.jpg'
      content = %(<item><media:content url="#{url}"></media:content></item>)

      parsed = described_class.new.parse(content)

      expect(parsed.primary_image_url).to eq url
    end

    it 'returns enclosure_url when valid and no media_content_url' do
      url = 'http://www.example.com/abc.jpg'
      content = %(<item><enclosure url="#{url}"></enclosure></item>)

      parsed = described_class.new.parse(content)

      expect(parsed.primary_image_url).to eq url
    end
  end
end

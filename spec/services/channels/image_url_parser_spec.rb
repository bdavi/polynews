# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Channels::ImageUrlParser, type: :service do
  context 'when item does not define image' do
    it 'returns the src of the first image tag' do
      url = 'http://www.example.com/abc.jpg'
      content = %(<div><img src="#{url}"></div>)
      item = OpenStruct.new(content: content)

      parser = described_class.new(item)

      expect(parser.url).to eq url
    end
  end

  context 'when the defined image is nil' do
    it 'returns the src of the first image tag' do
      url = 'http://www.example.com/abc.jpg'
      content = %(<div><img src="#{url}"></div>)
      item = OpenStruct.new(image: nil, content: content)

      parser = described_class.new(item)

      expect(parser.url).to eq url
    end
  end

  context 'when the defined image is nil and no <img> in the content' do
    it 'return nil' do
      content = %(<div>Hello</div>)
      item = OpenStruct.new(image: nil, content: content)

      parser = described_class.new(item)

      expect(parser.url).to be_nil
    end
  end

  context 'when the url is blacklisted' do
    it 'return nil' do
      url = 'http://www.example.com/tracking_pixel.jpg'
      item = OpenStruct.new(image: url)

      parser = described_class.new(item)

      expect(parser.url).to be_nil
    end
  end

  context 'when the url is ill formed but repairable' do
    it 'return the repaired url' do
      url = '//www.example.com/article.jpg'
      item = OpenStruct.new(image: url)

      parser = described_class.new(item)

      expect(parser.url).to eq 'http://www.example.com/article.jpg'
    end
  end

  context 'when the url is ill formed and cannot be repaired' do
    it 'return nil' do
      url = 'abc'
      item = OpenStruct.new(image: url)

      parser = described_class.new(item)

      expect(parser.url).to be_nil
    end
  end
end

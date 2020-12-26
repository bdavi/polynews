# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSS::EntryImageUrlParser do
  before do
    stub_const(
      'Entry',
      Struct.new(:enclosure_url, :content_first_image_url)
    )
  end

  describe '.url_for' do
    it 'returns the first non-nil url from the methods' do
      entry = Entry.new(nil, 'http://www.example.com/abc123.jpg')

      result = described_class.url_for(
        entry,
        %i[enclosure_url content_first_image_url]
      )

      expect(result).to eq 'http://www.example.com/abc123.jpg'
    end

    it 'ignores passed methods that the entry does not respond to' do
      entry = Entry.new('http://www.example.com/abc123.jpg')

      result = described_class.url_for(entry, %i[not_defined enclosure_url])

      expect(result).to eq 'http://www.example.com/abc123.jpg'
    end

    it 'repairs malformed urls' do
      entry = Entry.new('//www.example.com/abc123.jpg')

      result = described_class.url_for(entry, %i[enclosure_url])

      expect(result).to eq 'http://www.example.com/abc123.jpg'
    end

    it 'returns nil when the url is malformed and cannot be repaired' do
      entry = Entry.new('abc123')

      result = described_class.url_for(entry, %i[enclosure_url])

      expect(result).to be_nil
    end

    it 'returns nil when the url is blacklisted' do
      entry = Entry.new('www.abc.com/logo.png')

      result = described_class.url_for(entry, %i[enclosure_url])

      expect(result).to be_nil
    end
  end
end

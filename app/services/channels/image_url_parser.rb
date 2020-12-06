# frozen_string_literal: true

module Channels
  class ImageUrlParser
    BLACKLIST_PATTERNS = [/pixel/, /logo/, /blank/, /usatoday-newstopstories/].freeze
    REPAIR_PREFIXES = %w[http: http://].freeze

    attr_reader :item, :raw_url

    delegate :valid_url?, to: UrlValidator
    delegate :content, to: :item

    def initialize(item)
      @item = item
      @raw_url = init_raw_url
    end

    def url
      return nil unless raw_url
      return nil if image_url_is_blacklisted?(raw_url)
      return raw_url if valid_url?(raw_url)

      try_url_repair(raw_url)
    end

    private

    def init_raw_url
      # The xml parser doesn't always define #image on the item
      item_image = item.respond_to?(:image) ? item.image : nil

      item_image || content_first_image_url
    end

    def content_first_image_url
      Nokogiri::HTML(content)
        .css('img')
        .first
        &.attributes
        &.fetch('src', nil)
        &.value
    end

    def image_url_is_blacklisted?(url)
      BLACKLIST_PATTERNS.any? { |pattern| pattern.match? url }
    end

    def try_url_repair(url)
      REPAIR_PREFIXES.each do |prefix|
        repaired = "#{prefix}#{url}"
        return repaired if valid_url?(repaired)
      end

      nil
    end
  end
end

# frozen_string_literal: true

require 'feedjira'
require 'nokogiri'
require 'sax-machine'

module RSS
  class EntryParser
    include SAXMachine
    include Feedjira::FeedEntryUtilities

    attr_reader :raw_xml

    element :title

    element :"content:encoded", as: :content
    element :"a10:content", as: :content

    element :description, as: :description

    element :link, as: :url
    element :"a10:link", as: :url, value: :href

    element :author
    element :"dc:creator", as: :author
    element :"a10:name", as: :author

    element :pubDate, as: :published_at
    element :pubdate, as: :published_at
    element :issued, as: :published_at
    element :"dc:date", as: :published_at
    element :"dc:Date", as: :published_at
    element :"dcterms:created", as: :published_at

    element :"dcterms:modified", as: :updated
    element :"a10:updated", as: :updated

    element :guid, as: :entry_id, class: Feedjira::Parser::GloballyUniqueIdentifier
    element :"dc:identifier", as: :dc_identifier

    element :"media:thumbnail", as: :thumbnail_url, value: :url
    element :"media:content", as: :media_content_url, value: :url
    element :enclosure, as: :enclosure_url, value: :url

    elements :category, as: :categories

    def primary_image_url
      RSS::EntryImageUrlParser.url_for(
        self,
        %i[media_content_url enclosure_url]
      )
    end

    def thumbnail_image_url
      RSS::EntryImageUrlParser.url_for(self, %i[thumbnail_url])
    end

    def entry_id
      @entry_id&.guid
    end

    def url
      @url || @entry_id&.url
    end

    def id
      entry_id || @dc_identifier || @url
    end

    def article_attributes
      {
        title: title,
        description: description,
        published_at: published_at,
        content: content,
        url: url,
        primary_image_url: primary_image_url,
        thumbnail_image_url: thumbnail_image_url
      }
    end
  end
end

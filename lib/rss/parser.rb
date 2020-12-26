# frozen_string_literal: true

require 'feedjira'

module RSS
  class Parser
    include SAXMachine
    include Feedjira::FeedUtilities

    element :description
    element :image, class: Feedjira::Parser::RSSImage
    element :language
    element :lastBuildDate, as: :last_built
    element :link, as: :url
    element :'a10:link', as: :url, value: :href
    element :rss, as: :version, value: :version
    element :title
    element :ttl
    elements :'atom:link', as: :hubs, value: :href, with: { rel: 'hub' }
    elements :item, as: :entries, class: RSS::EntryParser

    attr_accessor :feed_url

    def self.able_to_parse?(xml)
      (/<rss|<rdf/ =~ xml) && xml.exclude?('feedburner')
    end
  end
end

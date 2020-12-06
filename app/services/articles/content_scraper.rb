# frozen_string_literal: true

require 'open-uri'

module Articles
  class ContentScraper < ApplicationService
    attr_reader :article, :html

    delegate :url, :channel, to: :article
    delegate :scraping_content_selector, to: :channel

    def initialize(article)
      @article = article
    end

    def call
      return success(:does_not_use_scraper) unless article.use_scraper
      return success(:already_scraped) if article.scraped_content

      download_html
      update_article
      success(:scraping_completed)
    end

    def download_html
      @html = URI.parse(url).read
    end

    def update_article
      article.update(scraped_content: parsed_content)
    end

    def parsed_content
      Nokogiri::HTML(html)
        .css(scraping_content_selector)
        .map(&:text)
        .join("\n")
    end
  end
end

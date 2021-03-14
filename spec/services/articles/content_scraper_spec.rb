# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Articles::ContentScraper, type: :service do
  describe '#call' do
    let(:url) do
      'https://www.reutersagency.com/en/reuters-best/reuters-first' \
        '-with-news-that-u-s-has-drafted-list-of-89-firms-with-military-ties-market-reacts/'
    end

    let(:selector) { '#main-content p' }

    let(:parsed_html) do
      'Reuters was first to report on Sunday that the Trump administration ' \
        'is close to declaring that 89 Chinese aerospace and other companies ' \
        'have military ties, restricting them from buying a range of U.S. ' \
        'goods and technology. The list, if published, could further ' \
        'escalate trade tensions with Beijing and hurt U.S. companies that ' \
        'sell civil aviation parts and components to China, among other ' \
        "industries.\nThe news pushed the yuan lower against the dollar on Monday."
    end

    context 'when not already scraped' do
      it 'saves the scraped and parsed content on the article' do
        channel = create(:channel, scraping_content_selector: selector, use_scraper: true)
        article = create(:article, url: url, scraped_content: nil, channel: channel)

        VCR.use_cassette('download_reuters_article', re_record_interval: 7.days) do
          described_class.new(article).call
          expect(article.scraped_content.strip).to eq parsed_html
        end
      end
    end

    context 'when already scraped' do
      it 'returns success but does not download' do
        channel = create(:channel, use_scraper: true)
        article = build_stubbed(:article, scraped_content: 'abc123', channel: channel)

        described_class.new(article).call

        expect(article.scraped_content).to eq 'abc123'
      end
    end

    context 'when the channel does not use the scraper' do
      it 'returns success and does not download' do
        channel = Channel.new(use_scraper: false)
        article = build_stubbed(:article, channel: channel)

        described_class.new(article).call

        expect(article.scraped_content).to be_nil
      end
    end
  end
end

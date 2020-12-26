# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Channels::FeedDownloader, type: :service do
  describe '#requires_update?' do
    it 'returns true when channel has no last_build_date' do
      channel = Channel.new(last_build_date: nil)
      downloader = described_class.new(channel)

      expect(downloader.requires_update?).to be true
    end
  end

  describe '#call' do
    context 'with too many invalid articles' do
      it 'raises ExceededMaxMalformedArticleCount' do
        channel = create(:channel, last_build_date: nil)

        created_items = Array.new(4).map { build_valid_feed_item }
        invalid_items = Array.new(2).map { build_invalid_feed_item }
        not_created_items = Array.new(4).map { build_valid_feed_item }
        items = created_items + invalid_items + not_created_items

        stub_rss_request_for_channel(channel, items)

        downloader = described_class.new(channel, allowed_invalid_entry_percent: 0.1)

        expect {
          downloader.call
        }.to raise_error(Channels::FeedDownloader::ExceededMaxInvalidEntryCount)
               .and change(Article, :count).by(4)

        expected_titles = created_items.pluck('title')
        created_titles = Article.all.pluck(:title)
        expect(expected_titles).to eq created_titles
      end
    end

    context 'with older articles' do
      it 'does not create the articles from before discard_articles_before' do
        discard_before = 1.week.ago
        channel = create(:channel, last_build_date: nil)
        current_items = Array.new(4).map do
          build_valid_feed_item('pubDate' => discard_before + 1.day)
        end
        too_old_items = Array.new(2).map do
          build_valid_feed_item('pubDate' => discard_before - 1.day)
        end
        items = current_items + too_old_items
        stub_rss_request_for_channel(channel, items)
        downloader = described_class.new(channel, discard_articles_before: discard_before)

        downloader.call

        expected_titles = current_items.pluck('title')
        created_titles = Article.all.pluck(:title)
        expect(expected_titles).to eq created_titles
      end
    end
  end

  context 'with a valid feed' do
    # NOTE: DO NOT UPDATE THE 'download_valid_feed' VCR CASSETTE WITHOUT
    # ALSO UPDATING THE FOLLOWING LET BLOCKS.
    #
    # The 'with a valid feed' specs depend on the current values in
    # that cassette (which does not expire). Coupling the specs to the fixture
    # in this way isn't ordinarily ideal, but because the RSS standard is
    # unlikey to change we are reasonably safe.

    around { |example| VCR.use_cassette('download_valid_feed', &example) }

    let(:cassette_data) do
      {
        last_build: DateTime.new(2020, 11, 20, 16, 55, 56).utc,
        channel_title: 'Reuters News Agency',
        channel_image_url: 'https://www.reutersagency.com/wp-content/uploads/' \
          '2019/06/fav-150x150.png',
        item_count: 10,
        first_item: {
          title: 'Reuters ahead with Turkey interest rate hike; market reacts',
          guid: 'https://www.reutersagency.com/en/?post_type=best&p=223646',
          published_at: DateTime.new(2020, 11, 19, 19, 1, 59),
          description: '<p>Reuters was ahead in reporting Turkey&#8217;s ' \
            'central bank aggressively raising its policy rate by 475 basis' \
            " points to 15% on [&#8230;]</p>\n<p>The post <a rel=\"no" \
            'follow" href="https://www.reutersagency.com/en/reuters-best/' \
            'reuters-ahead-with-turkey-interest-rate-hike-market-' \
            'reacts/">Reuters ahead with Turkey interest rate hike; market ' \
            'reacts</a> appeared first on <a rel="nofollow" href="https' \
            "://www.reutersagency.com/en/\">Reuters News Agency</a>.</p>\n",
          content: "\n<p>Reuters was ahead in reporting Turkey&#8217;s " \
            'central bank <a href="http://trreuters.us.newsweaver.com/' \
            'reutersbestflash/fxlmqe5ve08fcw1nmos5t1/external?email=true&' \
            'amp;a=5&amp;p=9527331&amp;t=488545">aggressively raising</a>' \
            ' its policy rate by 475 basis points to 15% on Nov. 19, at the ' \
            'closely-watched first meeting on rates since the appointment ' \
            "of a new governor, Naci Agbal.</p>\n\n\n\n<figure class=\"wp-" \
            'block-image size-large"><img src="https://www.reutersagency.' \
            'com/wp-content/uploads/2020/11/Lira-1024x907.png" alt="" class' \
            '="wp-image-223658" srcset="https://www.reutersagency.com/wp-' \
            'content/uploads/2020/11/Lira-1024x907.png 1024w, https://www.' \
            'reutersagency.com/wp-content/uploads/2020/11/Lira-980x868.png 980w' \
            ', https://www.reutersagency.com/wp-content/uploads/2020/11/Lira-' \
            '480x425.png 480w" sizes="(min-width: 0px) and (max-width: ' \
            '480px) 480px, (min-width: 481px) and (max-width: 980px) 980px, ' \
            "(min-width: 981px) 1024px, 100vw\" /></figure>\n<p>The post <a " \
            'rel="nofollow" href="https://www.reutersagency.com/en/' \
            'reuters-best/reuters-ahead-with-turkey-interest-rate-hike-' \
            'market-reacts/">Reuters ahead with Turkey interest rate hike;' \
            ' market reacts</a> appeared first on <a rel="nofollow" href' \
            '="https://www.reutersagency.com/en/">Reuters News Agency' \
            "</a>.</p>\n",
          url: 'https://www.reutersagency.com/en/reuters-best/reuters-' \
            'ahead-with-turkey-interest-rate-hike-market-reacts/'
        }
      }
    end
    let(:url) { 'https://www.reutersagency.com/feed/?taxonomy=best-topics&post_type=best' }
    let(:downloaded_day_before_last_build) { cassette_data[:last_build] - 1.day }
    let(:downloaded_on_last_build) { cassette_data[:last_build] }

    def new_channel(last_build_date = DateTime.now)
      Channel.new(url: url, last_build_date: last_build_date)
    end

    def create_channel(last_build_date = DateTime.now)
      create(:channel, url: url, last_build_date: last_build_date)
    end

    describe '#download_feed' do
      it 'downloads and parses the feed' do
        downloader = described_class.new(new_channel)

        downloader.download_feed
        parsed_download = downloader.feed

        expect(parsed_download.title).to eq cassette_data[:channel_title]
        expect(Time.parse(parsed_download.last_built).utc).to eq cassette_data[:last_build]
        expect(parsed_download.entries.first.title).to eq cassette_data[:first_item][:title]
      end
    end

    describe '#requires_update?' do
      it 'returns true when the download is stale' do
        channel = new_channel(downloaded_day_before_last_build)
        downloader = described_class.new(channel).tap(&:download_feed)

        expect(downloader.requires_update?).to be true
      end

      it 'returns false when download is current' do
        channel = new_channel(downloaded_on_last_build)
        downloader = described_class.new(channel).tap(&:download_feed)

        expect(downloader.requires_update?).to be false
      end
    end

    describe '#update_channel' do
      it 'updates the last_build_date from the feed' do
        channel = create_channel(downloaded_day_before_last_build)
        downloader = described_class.new(channel).tap(&:download_feed)

        downloader.update_channel

        channel.reload
        expect(channel.last_build_date).to eq cassette_data[:last_build]
      end
    end

    describe '#create_or_update_articles' do
      it 'creates articles from the feed' do
        channel = create_channel(downloaded_day_before_last_build)
        downloader = described_class.new(
          channel,
          discard_articles_before: cassette_data[:first_item][:published_at] - 1.month
        ).tap(&:download_feed)

        expect {
          downloader.create_or_update_articles
        }.to change(Article, :count).by(cassette_data[:item_count])

        article = Article.find_by(guid: cassette_data[:first_item][:guid])
        expect(article).to have_attributes(cassette_data[:first_item])
        expect(article.channel).to eq channel
      end
    end

    describe '#call' do
      it 'downloads the feed and updates' do
        channel = create_channel(downloaded_day_before_last_build)
        downloader = described_class.new(
          channel,
          discard_articles_before: cassette_data[:first_item][:published_at] - 1.month
        )

        expect do
          downloader.call
        end.to change(Article, :count).by(cassette_data[:item_count])

        expect(downloader.feed).not_to be_nil
        expect(channel.reload.last_build_date).to eq cassette_data[:last_build]
      end

      it 'downloads the feed but does not update when already current' do
        channel = create_channel(downloaded_on_last_build)
        downloader = described_class.new(channel)

        expect do
          downloader.call
        end.not_to change(Article, :count)

        expect(downloader.feed).not_to be_nil
        expect(channel.reload.last_build_date).to eq cassette_data[:last_build]
      end
    end
  end

  def build_valid_feed_item(opts = {})
    map = { url: 'link', published_at: 'pubDate', title: 'title' }

    attributes_for(:article, published_at: DateTime.now)
      .slice(:guid, :title, :url, :published_at)
      .transform_keys { |key| map[key] || key.to_s }
      .merge(opts)
  end

  def build_invalid_feed_item
    build_valid_feed_item.tap do |item|
      item['link'] = 'invalid url'
    end
  end

  def stub_rss_request_for_channel(channel, items)
    body = {
      channel: { title: channel.title, link: channel.url },
      items: items
    }.to_xml(root: 'rss')

    stub_request(:get, channel.url).to_return(status: 201, headers: {}, body: body)
  end
end

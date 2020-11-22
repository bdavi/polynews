# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Channels::FeedSynchronizer, type: :service do
  # NOTE: These specs rely on the 'download_valid_feed' VCR cassette.
  # If you update this cassette you will need to update these values
  let(:valid_feed_url) do
    'https://www.reutersagency.com/feed/?taxonomy=best-topics&post_type=best'
  end
  let(:valid_feed_last_build) { DateTime.new(2020, 11, 20, 16, 55, 56) }
  let(:valid_feed_channel_title) { 'Reuters News Agency' }
  let(:valid_feed_item_count) { 10 }
  let(:valid_feed_first_item) do
    {
      title: 'Reuters ahead with Turkey interest rate hike; market reacts',
      guid: 'https://www.reutersagency.com/en/?post_type=best&p=223646',
      published_at: DateTime.new(2020, 11, 19, 19, 1, 59),
      description: 'Reuters was ahead in reporting Turkey’s central bank aggressively raising ' \
        "its policy rate by 475 basis points to 15% on […]\nThe post Reuters ahead with Turkey " \
        "interest rate hike; market reacts appeared first on Reuters News Agency.\n",
      content: "\nReuters was ahead in reporting Turkey’s central bank aggressively raising its " \
        'policy rate by 475 basis points to 15% on Nov. 19, at the closely-watched first ' \
        "meeting on rates since the appointment of a new governor, Naci Agbal.\n\n\n\n\nThe " \
        'post Reuters ahead with Turkey interest rate hike; market reacts appeared first on ' \
        "Reuters News Agency.\n"
    }
  end

  describe '#download_feed' do
    context 'when the feed is valid' do
      it 'downloads and parses the feed' do
        synchronizer = synchronizer_with_valid_feed_and_stubbed_channel
        feed = synchronizer.feed

        expect(feed.channel.title).to eq valid_feed_channel_title
        expect(feed.channel.lastBuildDate).to eq valid_feed_last_build
        expect(feed.items.first.title).to eq valid_feed_first_item[:title]
      end
    end

    context 'when the feed is invalid' do
      it 'raises an error' do
        channel = build_stubbed(:channel, url: 'https://www.google.com')
        synchronizer = described_class.new(channel)

        VCR.use_cassette('download_invalid_feed') do
          expect {
            synchronizer.download_feed
          }.to raise_error(RSS::NotWellFormedError)
        end
      end
    end
  end

  describe '#requires_update?' do
    context 'when channel has no last_build_date' do
      it 'returns true' do
        channel = build_stubbed(:channel, last_build_date: nil)
        synchronizer = described_class.new(channel)

        expect(synchronizer.requires_update?).to be true
      end
    end

    context 'when the channel last build is before the feed last build' do
      it 'returns true' do
        synchronizer = synchronizer_with_valid_feed_and_stubbed_channel(
          channel_last_build: valid_feed_last_build - 1.day
        )

        expect(synchronizer.requires_update?).to be true
      end
    end

    context 'when the channel last build is equal to the feed last build' do
      it 'returns false' do
        synchronizer = synchronizer_with_valid_feed_and_stubbed_channel(
          channel_last_build: valid_feed_last_build
        )

        expect(synchronizer.requires_update?).to be false
      end
    end
  end

  describe '#update_channel' do
    it 'updates the last_build_date from the feed' do
      synchronizer = synchronizer_with_valid_feed_and_persisted_channel(
        channel_last_build: valid_feed_last_build - 1.day
      )
      channel = synchronizer.channel

      synchronizer.update_channel
      channel.reload
      expect(channel.last_build_date).to eq valid_feed_last_build
    end
  end

  describe '#update_articles' do
    it 'creates articles from the feed' do
      synchronizer = synchronizer_with_valid_feed_and_persisted_channel
      channel = synchronizer.channel

      synchronizer.update_articles

      channel.reload
      expect(channel.articles.count).to eq valid_feed_item_count

      article = Article.find_by(guid: valid_feed_first_item[:guid])
      expect(article).to have_attributes(valid_feed_first_item)
      expect(article.channel).to eq channel
    end
  end

  describe '#call' do
    context 'when an update is required' do
      it 'downloads the feed and updates' do
        synchronizer = synchronizer_with_valid_feed_and_persisted_channel(
          channel_last_build: valid_feed_last_build - 1.day
        )

        expect(synchronizer).to receive(:download_feed).and_call_original
        expect(synchronizer).to receive(:update_channel).and_call_original
        expect(synchronizer).to receive(:update_articles).and_call_original

        VCR.use_cassette('download_valid_feed') do
          synchronizer.call
        end
      end
    end

    context 'when an update is not required' do
      it 'downloads the feed but does not updates' do
        synchronizer = synchronizer_with_valid_feed_and_persisted_channel(
          channel_last_build: valid_feed_last_build
        )

        expect(synchronizer).to receive(:download_feed).and_call_original
        expect(synchronizer).not_to receive(:update_channel).and_call_original
        expect(synchronizer).not_to receive(:update_articles).and_call_original

        VCR.use_cassette('download_valid_feed') do
          synchronizer.call
        end
      end
    end
  end

  def synchronizer_with_valid_feed_and_stubbed_channel(channel_last_build: DateTime.now)
    channel = build_stubbed(:channel, url: valid_feed_url, last_build_date: channel_last_build)
    synchronizer_with_downlaoded_valid_feed(channel)
  end

  def synchronizer_with_valid_feed_and_persisted_channel(channel_last_build: DateTime.now)
    channel = create(:channel, url: valid_feed_url, last_build_date: channel_last_build)
    synchronizer_with_downlaoded_valid_feed(channel)
  end

  def synchronizer_with_downlaoded_valid_feed(channel)
    synchronizer = described_class.new(channel)

    VCR.use_cassette('download_valid_feed') do
      synchronizer.download_feed
    end

    synchronizer
  end
end

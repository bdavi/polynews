# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Groups::Creator, type: :service do
  describe '#call' do
    context 'when there is an article with no matching exiting group' do
      it 'creates a new group for the article' do
        channel = create(:channel, :with_category)
        category = channel.category
        existing_article = create(
          :article,
          :uses_scraper,
          channel: channel,
          title: 'One fish, two fish, red fish, blue fish',
          scraped_content: 'From there to here, from here to there, funny things are everywhere!'
        )
        existing_group = create(:group, category: category, articles: [existing_article])

        published_at = Time.new(2020, 1, 1).utc
        orphan_article = create(
          :article,
          :uses_scraper,
          channel: channel,
          title: 'The cat in the hat',
          scraped_content: '“Now! Now! Have no fear. Have no fear!” said the cat. ' \
            '“My tricks are not bad,” said the Cat in the Hat.',
          published_at: published_at
        )
        creator = described_class.new

        expect {
          creator.call(
            groups: category.groups,
            articles: category.articles,
            max_angle_between_articles: 1.3
          )
        }.to change(Group, :count).by(1)

        orphan_article.reload
        group = orphan_article.group
        group.reload

        expect(group).not_to eq existing_group
        expect(group.cached_article_count).to eq 1
        expect(group.cached_article_last_published_at).to eq published_at
      end
    end

    context 'when there is an article with a matching exiting group' do
      it 'adds the article to the group, updates group cache' do
        channel = create(:channel, :with_category)
        category = channel.category
        latest_published_at = Time.new(2020, 1, 1).utc
        existing_article = create(
          :article,
          :uses_scraper,
          channel: channel,
          title: 'One fish, two fish, red fish, blue fish',
          scraped_content: 'From there to here, from here to there, funny things are everywhere!',
          published_at: latest_published_at
        )
        existing_group = create(:group, category: category, articles: [existing_article])
        orphan_article = create(
          :article,
          :uses_scraper,
          channel: channel,
          title: 'The cat in the hat',
          scraped_content: '“Now! Now! Have no fear. Have no fear!” said the cat. ' \
            '“My tricks are not bad,” said the Cat in the Hat.',
          published_at: latest_published_at - 1.day
        )
        creator = described_class.new

        expect {
          creator.call(
            groups: category.groups,
            articles: category.articles,
            max_angle_between_articles: 1.6
          )
        }.not_to change(Group, :count)

        orphan_article.reload
        existing_group.reload

        expect(orphan_article.group).to eq existing_group
        expect(existing_group.cached_article_count).to eq 2
        expect(existing_group.cached_article_last_published_at).to eq latest_published_at
      end
    end
  end
end

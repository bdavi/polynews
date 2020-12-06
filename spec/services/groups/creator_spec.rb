# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Groups::Creator, type: :service do
  describe '#call' do
    context 'when there is an article with no matching exiting group' do
      it 'creates a new group for the article' do
        existing_article = create(
          :article,
          :uses_scraper,
          title: 'One fish, two fish, red fish, blue fish',
          scraped_content: 'From there to here, from here to there, funny things are everywhere!'
        )
        existing_group = create(:group, articles: [existing_article])

        published_at = Time.new(2020, 1, 1).utc
        orphan_article = create(
          :article,
          :uses_scraper,
          title: 'The cat in the hat',
          scraped_content: '“Now! Now! Have no fear. Have no fear!” said the cat. ' \
            '“My tricks are not bad,” said the Cat in the Hat.',
          published_at: published_at
        )
        creator = described_class.new(max_angle_between_articles: 1.3)

        expect {
          creator.call
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
      it 'creates adds the article to the group' do
        latest_published_at = Time.new(2020, 1, 1).utc
        existing_article = create(
          :article,
          :uses_scraper,
          title: 'One fish, Two fish, Red fish, Blue fish,',
          scraped_content: 'Black fish, Blue fish, Old fish, New fish.',
          published_at: latest_published_at
        )
        existing_group = create(:group, articles: [existing_article])
        orphan_article = create(
          :article,
          :uses_scraper,
          title: 'Some are sad. And some are glad.',
          scraped_content: 'And some are very, very bad.',
          published_at: latest_published_at - 1.day
        )
        creator = described_class.new(max_angle_between_articles: 1.6)

        expect {
          creator.call
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

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
        orphan_article = create(
          :article,
          :uses_scraper,
          title: 'The cat in the hat',
          scraped_content: '“Now! Now! Have no fear. Have no fear!” said the cat. ' \
            '“My tricks are not bad,” said the Cat in the Hat.'
        )
        creator = described_class.new(max_angle_between_articles: 1.3)

        expect {
          creator.call
        }.to change(Group, :count).by(1)

        orphan_article.reload
        expect(orphan_article.group).not_to be_nil
        expect(orphan_article.group).not_to eq existing_group
      end
    end

    context 'when there is an article with a matching exiting group' do
      it 'creates adds the article to the group' do
        existing_article = create(
          :article,
          :uses_scraper,
          title: 'One fish, Two fish, Red fish, Blue fish,',
          scraped_content: 'Black fish, Blue fish, Old fish, New fish.'
        )
        existing_group = create(:group, articles: [existing_article])
        orphan_article = create(
          :article,
          :uses_scraper,
          title: 'Some are sad. And some are glad.',
          scraped_content: 'And some are very, very bad.'
        )
        creator = described_class.new(max_angle_between_articles: 1.6)

        expect {
          creator.call
        }.not_to change(Group, :count)

        orphan_article.reload
        expect(orphan_article.group).to eq existing_group
      end
    end

    context 'when there is an error' do
      it 'returns a failure object' do
        allow(NLP::BOW::Model).to receive(:new).and_raise(StandardError, 'abc123')
        creator = described_class.new(max_angle_between_articles: 1.6)

        result = creator.call

        expect(result).not_to be_success
        expect(result.error).to be_a StandardError
        expect(result.error.message).to eq 'abc123'
      end
    end
  end
end

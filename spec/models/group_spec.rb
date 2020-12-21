# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  it :aggregate_failures do
    is_expected.to belong_to(:category).optional(true)
    is_expected.to have_many(:articles).dependent(:restrict_with_error)
  end

  describe '.update_cached_attributes!' do
    it 'updates the cached attributes for all records' do
      some_group = create(
        :group,
        :with_articles,
        article_count: 2,
        cached_article_count: 0,
        cached_article_last_published_at: nil
      )

      other_group = create(
        :group,
        :with_articles,
        article_count: 4,
        cached_article_count: 0,
        cached_article_last_published_at: nil
      )

      described_class.all.update_cached_attributes!

      some_group.reload
      other_group.reload

      expect(some_group.cached_article_count).to eq 2
      expect(some_group.cached_article_last_published_at).to \
        eq some_group.articles.pluck(:published_at).max

      expect(other_group.cached_article_count).to eq 4
      expect(other_group.cached_article_last_published_at).to \
        eq other_group.articles.pluck(:published_at).max
    end
  end
end

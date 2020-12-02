# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  it :aggregate_failures do
    is_expected.to belong_to(:category).optional(true)
    is_expected.to have_many(:articles).dependent(:restrict_with_error)
  end

  describe '#update_cached_attributes' do
    it 'sets cached values' do
      group = create(:group)
      latest_published_at = Time.new(2020, 1, 1, 0, 0).utc
      create(:article, group: group, published_at: latest_published_at)
      create(:article, group: group, published_at: latest_published_at - 1.day)

      group.update_cached_attributes

      expect(group.cached_article_count).to eq 2
      expect(group.cached_article_last_published_at).to eq latest_published_at
    end
  end
end

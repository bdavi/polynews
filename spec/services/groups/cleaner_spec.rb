# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Lint/UselessAssignment
RSpec.describe Groups::Cleaner, type: :service do
  describe '#call' do
    it 'deletes articles older than clean_before' do
      clean_before = DateTime.now - 24.hours
      should_delete = create(:article, :with_group, published_at: clean_before - 1.hour)
      should_not_delete = create(:article, :with_group, published_at: clean_before + 1.hour)
      cleaner = described_class.new(clean_before)

      cleaner.call

      expect(Article.all).to eq [should_not_delete]
    end

    it 'deletes articles without groups regardless of published_at' do
      clean_before = DateTime.now - 24.hours
      create(:article, group: nil, published_at: clean_before + 1.hour)
      cleaner = described_class.new(clean_before)

      cleaner.call

      expect(Article.all).to be_empty
    end

    it 'deletes empty groups' do
      clean_before = DateTime.now - 24.hours
      should_delete = create(:group)
      should_not_delete = create(:group).tap do |group|
        create(:article, group: group)
      end
      cleaner = described_class.new(clean_before)

      cleaner.call

      expect(Group.all).to eq [should_not_delete]
    end

    it 'deletes groups that are empty because of the cleaning' do
      clean_before = DateTime.now - 24.hours
      should_delete = create(:group).tap do |group|
        create(:article, group: group, published_at: clean_before - 1.day)
      end
      should_not_delete = create(:group).tap do |group|
        create(:article, group: group, published_at: clean_before + 1.day)
      end
      cleaner = described_class.new(clean_before)

      expect {
        cleaner.call
      }.to change(Article, :count).by(-1).and change(Group, :count).by(-1)

      expect(Group.all).to eq [should_not_delete]
    end
  end
end
# rubocop:enable Lint/UselessAssignment

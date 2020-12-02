# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Groups::Cleaner, type: :service do
  describe '#call' do
    it 'deletes articles older than clean_before' do
      clean_before = DateTime.now - 24.hours
      should_delete = create(:article, published_at: clean_before - 1.hour) # rubocop:disable Link/UselessAssignment
      should_not_delete = create(:article, published_at: clean_before + 1.hour)
      cleaner = described_class.new(clean_before)

      cleaner.call

      expect(Article.all).to eq [should_not_delete]
    end

    it 'deletes empty groups' do
      clean_before = DateTime.now - 24.hours
      should_delete = create(:group) # rubocop:disable Link/UselessAssignment
      should_not_delete = create(:group).tap do |group|
        create(:article, group: group)
      end
      cleaner = described_class.new(clean_before)

      cleaner.call

      expect(Group.all).to eq [should_not_delete]
    end

    it 'deletes groups that are empty because of the cleaning' do
      clean_before = DateTime.now - 24.hours
      should_delete = create(:group).tap do |group| # rubocop:disable Link/UselessAssignment
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

    context 'when there is an error' do
      it 'rescues the error and reports failure' do
        allow(Article).to receive(:where).and_raise(StandardError, 'abc123')
        cleaner = described_class.new

        expect {
          result = cleaner.call
          expect(result).not_to be_success
          expect(result.error).to be_a StandardError
          expect(result.error.message).to eq 'abc123'
        }.not_to raise_error
      end
    end
  end
end

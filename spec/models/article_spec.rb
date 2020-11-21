# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  subject(:article) { described_class.new }

  it :aggregate_failures do
    is_expected.to validate_presence_of :title
    is_expected.to validate_presence_of(:channel).with_message('must exist')
  end

  describe 'url uniqueness' do
    subject(:article) { build(:article) }

    it { is_expected.to validate_uniqueness_of :guid }
  end
end

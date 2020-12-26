# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Groups::FeaturedQuery do
  it 'returns the correct records' do
    featured = create(:group, :featured)
    create(:group, :emphasized)
    create(:group, :minimized_by_count)

    expect(described_class.call).to eq [featured]
  end
end

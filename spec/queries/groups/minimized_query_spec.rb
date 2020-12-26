# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Groups::MinimizedQuery do
  it 'returns the correct records' do
    minimized_by_count = create(:group, :minimized_by_count)
    minimized_by_absence_of_image = create(:group, :minimized_by_absence_of_image)

    create(:group, :emphasized)
    create(:group, :featured)

    expect(described_class.call).to eq [minimized_by_count, minimized_by_absence_of_image]
  end
end

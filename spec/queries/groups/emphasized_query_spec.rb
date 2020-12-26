# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Groups::EmphasizedQuery do
  it 'returns the correct records' do
    emphasized = create(:group, :emphasized)
    create(:group, :featured)
    create(:group, :minimized_by_count)

    expect(described_class.call).to eq [emphasized]
  end
end

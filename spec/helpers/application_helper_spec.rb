# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#coalesce' do
    it 'returns the first non-blank value' do
      values = [nil, '', " \n\t", 'abc123', 44]

      expect(helper.coalesce(*values)).to eq 'abc123'
    end
  end

  describe '#coalesce_to_empty' do
    it 'returns the empty element when passed empty values' do
      values = [nil, '']

      expect(helper.coalesce_to_empty(*values)).to eq \
        '<em class="text-black-50">Empty</em>'.html_safe
    end
  end
end

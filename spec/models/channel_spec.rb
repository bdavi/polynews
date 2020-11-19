# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Channel, type: :model do
  it :aggregate_failures do
    is_expected.to validate_presence_of :title
    is_expected.to validate_presence_of :url

    is_expected.to validate_url_format_of :url
  end
end

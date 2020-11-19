# frozen_string_literal: true

# Load custom matchers
Dir[Rails.root.join('spec/matchers/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.include Matchers
end

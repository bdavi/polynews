require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'

  minimum_coverage 90
end

require 'webmock/rspec'
require 'test-prof'
require 'vcr'
require_relative 'support/helpers'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include SpecHelpers

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
end

# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  Feedjira.configure do |config|
    config.parsers.unshift(RSS::Parser)
  end
end

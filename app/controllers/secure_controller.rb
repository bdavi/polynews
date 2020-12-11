# frozen_string_literal: true

class SecureController < ApplicationController
  if Rails.env.production?
    http_basic_authenticate_with(
      name: ENV['ADMIN_USERNAME'],
      password: ENV['ADMIN_PASSWORD']
    )
  end
end

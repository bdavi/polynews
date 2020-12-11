# frozen_string_literal: true

class SecureController < ApplicationController
  if Rails.env.production?
    http_basic_authenticate_with(
      name: Rails.env['ADMIN_USERNAME'],
      password: Rails.env['ADMIN_PASSWORD']
    )
  end
end

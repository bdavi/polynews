# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types :error, :success, :warning, :notice
end

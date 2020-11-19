# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'channels#index'

  resources :channels
end

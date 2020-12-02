# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'channels#index'

  resources :articles
  resources :categories
  resources :channels
  resources :groups
end

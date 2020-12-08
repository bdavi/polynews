# frozen_string_literal: true

Rails.application.routes.draw do
  resources :articles
  resources :categories
  resources :channels
  resources :groups

  get 'news/:category', to: 'news#show', as: :news
  root to: redirect('news/headlines')
end

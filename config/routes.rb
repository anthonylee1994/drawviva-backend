# frozen_string_literal: true

Rails.application.routes.draw do
  post '/login', to: 'auth#login'
  resources :draws
  resources :user_draws, only: %i[create destroy]
end

# frozen_string_literal: true

Rails.application.routes.draw do
  post '/login', to: 'auth#login'
  get '/me', to: 'auth#me'
  put '/me', to: 'auth#update'

  resources :draws do
    resources :draw_items, only: %i[create]
  end

  resources :user_draws, only: %i[create destroy]
  resources :draw_items, only: %i[update destroy]

  post '/draws/:draw_id/draw', to: 'draw_items#draw'
end

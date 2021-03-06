# frozen_string_literal: true

Rails.application.routes.draw do
  post '/login', to: 'auth#login'

  get '/me', to: 'users#me'
  put '/me', to: 'users#update'
  get '/users', to: 'users#index'


  resources :draws do
    resources :draw_items, only: %i[create]
  end

  resources :upload, only: %i[create]
  resources :user_draws, only: %i[create update destroy]
  resources :draw_items, only: %i[update destroy]

  post '/draws/:draw_id/draw', to: 'draw_items#draw'
end

# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  devise_scope :user do
    post '/users/guest_sign_in', to: 'users/sessions#new_guest'
  end
  root to: 'home#index'
  resources :media_manages do
    patch 'restore', on: :member
    patch 'fetch', on: :member
    patch 'do_not_watch', on: :member
    patch 'cancel_do_not_watch', on: :member
  end
  resources :playlists
  resource :playlist_orders, only: :update
  resources :playlist_media_manages, only: [:create, :destroy]
  resources :media_time_span, only: [:create, :destroy]
  resource :finish_watching, only: :create
  resources :media_time_images, only: [:create, :destroy]

  mount LetterOpenerWeb::Engine, at: '/lo' if Rails.env.development?
end

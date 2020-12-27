# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :media_manages do
    patch 'restore', on: :member
  end
  resources :media_time_span
  resources :media_time_images, only: [:create, :destroy]
end

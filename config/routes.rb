
Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :media_manages do
    patch 'restore', on: :member
  end
  resources :media_time_span, only: [:create, :destroy]
  resources :media_time_images, only: [:create, :destroy]

  mount LetterOpenerWeb::Engine, at: '/lo' if Rails.env.development?
end

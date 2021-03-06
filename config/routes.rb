require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  get '/help', to: 'home#help'
  mount Monologue::Engine, at: '/blog'

  resource :facebook_webhook
  namespace :api do
    resources :customers, only: [:show]
  end

  namespace :admin do
    mount Sidekiq::Web, at: '/sidekiq'
    
    resources :customers do
      collection do
        get :autocomplete
        get :sync_google_drive
      end
    end

    resources :weeks do
      get :add_customer
      get :get_facebook_orders
      get :ship_info
      delete :remove_customer

      resources :products
    end

    resources :orders
    resources :confirm_orders
  end
end

Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  resource :facebook_webhook

  namespace :admin do
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

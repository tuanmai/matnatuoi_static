Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  resources :customers do
    collection do
      get :autocomplete
    end
  end

  resources :orders do
    get :add_customer
    delete :remove_customer
  end
end

Rails.application.routes.draw do

  root 'products#index'

  get 'users/orders', to: 'users#list_of_orders', as: 'users_orders'

  resources :users, only: [ :show, :new, :create ] do
    resources :products, only: [ :new, :create, :edit, :update ] do
      collection do
        get 'index', to: 'products#merchant', as: 'my'
      end
    end
  end

  resources :products, except: [ :new, :create, :edit, :update ] do
    collection do
      get 'by_vendor', to: "products#by_vendor", as: 'by_vendor'
      get 'by_category', to: "products#by_category", as: 'by_category'
    end
    resources :reviews, only: [:new, :create]
  end

  resources :orders, except: [ :new, :create, :edit ] do
    resources :order_items, only: [ :index, :create, :destroy]
  end

  resources :categories, only: [ :new, :create ]

  post   "/login",  to: 'sessions#create'
  delete "/logout", to: 'sessions#destroy', as: 'logout'

  post 'order_items/:id/qty_increase', to: 'order_items#qty_increase', as: 'order_items_increase'
  post 'order_items/:id/qty_decrease', to: 'order_items#qty_decrease', as: 'order_items_decrease'

  get 'orders/:id/payment', to: 'orders#payment', as: 'order_payment'
  put 'orders/:id/payment', to: 'orders#payment'

  get 'orders/:id/confirmation', to: 'orders#confirmation', as: 'order_confirmation'
  get 'orders/:id/completed', to: 'orders#completed', as: 'shipped_order'

  # For interaction with FEDAX
  get 'orders/:id/estimate_form', to: 'orders#shipping', as: 'new_estimate'

  get 'orders/:id/estimate', to: 'orders#estimate', as: 'estimate'
  patch 'orders/:id/estimate', to: 'orders#estimate'

  patch 'orders/:id/shipping', to: 'orders#ship_update', as: "ship_update"
end

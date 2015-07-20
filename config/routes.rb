Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'products#index'
  resources :users, :orders, :order_items, :reviews

  resources :products do
    collection do
      get 'by_vendor', to: "products#by_vendor", as: 'by_vendor'
      get 'by_category', to: "products#by_category", as: 'by_category'
    end
  end

  get    "/login",  to: 'sessions#new',     as: 'login'
  post   "/login",  to: 'sessions#create'
  delete "/logout", to: 'sessions#destroy', as: 'logout'

  post 'order_items/:id/qty_increase' => 'order_items#qty_increase', as: 'order_items_increase'
  post 'order_items/:id/qty_decrease' => 'order_items#qty_decrease', as: 'order_items_decrease'

  get 'orders/:id/payment' => 'orders#payment', as: 'order_payment'
  post 'orders/:id/payment' => 'orders#payment'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # Adding all now for testing purposes; will prune routes later.

end

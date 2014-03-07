Pozitiva::Application.routes.draw do

  devise_for :users

  resources :profiles, only: [:show, :update] do
    member do
      get 'about_attach'
      get 'delete_about_attach'
      post 'message'
    end
  end
  get 'my_profile' => 'profiles#my_profile'
  
  resources :locations
  
  resources :offers do
    member do 
      get 'duplicate'
      get 'deactivate'
      get 'attach'
      get 'delete_attach'
      post 'message_to_orderers'
    end
    resources :orders do
      resources :order_items, only: :destroy
    end
  end
  
  get 'my_orders'    => 'orders#my_orders'
  get 'my_offers'    => 'offers#my_offers'
  get 'admin_offers' => 'offers#admin'
  get 'admin_orders' => 'orders#admin'
  
  get 'help'     => 'static_pages#help'
  get 'manifest' => 'static_pages#manifest'
  
  namespace :admin do
    resources :users
  end
  
  # get 'how' => 'static_pages#how_it_works'
 
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static_pages#home'

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
end

Pozitiva::Application.routes.draw do

  devise_for :users

  resources :profiles, only: [:show, :update] do
    member do
      get 'about_attach'
      delete 'about_attach' => 'profiles#delete_about_attach'
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
      get 'print_orders'
      get 'print_orders_per_item'
      get 'print_dispatch_notes'
      post 'message_to_orderers'
      post 'save_sort_order'
    end
    resources :offer_items do
      get 'activate', on: :member, to: 'offers#activate_item'
      get 'deactivate', on: :member, to: 'offers#deactivate_item'
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
  get 'info-gsr-pozitiva' => 'static_pages#info_gsr_pozitiva'
  get 'info-gsr-puslek'   => 'static_pages#info_gsr_puslek'
  get 'recipes'   => 'static_pages#recipes'
  
  namespace :admin do
    resources :users do
      get 'print', on: :collection
    end
    post 'clean_older_than' => 'cleanup#clean_older_than'
    get 'export' => 'export#index'
    
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

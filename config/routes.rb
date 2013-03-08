NewrevF::Application.routes.draw do
  devise_for :users
  get 'checkin/search' => 'checkin#search', as: :checkin_search
  
  
  resources :attendances do
    member do
      get 'checkout'
    end
  end
  resources :settings
  resources :meetings
  resources :checkin do
    collection do
      get 'checkin_selected'
    end
  end
  
  post 'checkin/checkin_selected' => 'checkin#checkin_selected', as: :checkin_selected

  resources :instances

  resources :events do
    collection do
      get 'search'
    end
    member do
      get 'mark'
      post 'post'
    end
  end

  resources :event_types do
    member do
      get 'add_instance_type_to'
      get 'remove_instance_type_from'
    end
  end

  resources :instance_types do
    member do
      get 'add_group_to'
      get 'remove_group_from'
    end
  end

  resources :rooms

  resources :groups

  resources :emails

  resources :phones

  resources :people do
    member do
      get 'edit_image'
      put 'update_image'
    end
  end

  resources :households

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: 'households#index' #TODO: change this to dashboard

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

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  get 'search/do' => 'search#do', :as => :do_search
  
end

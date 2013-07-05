NewrevF::Application.routes.draw do
  get "orphans/people"
  
  get "preferences/edit_fav_instance", to: "preferences#edit_fav_instance", as: :edit_fav_instance
  post "preferences/set_fav_instance", to: "preferences#set_fav_instance", as: :set_fav_instance
  get "preferences/clear_fav_instance", to: "preferences#clear_fav_instance", as: :clear_fav_instance
  
  resources :leaderships

  resources :cadences

  resources :meeting_times

  resources :reports

  resources :donations
  resources :checkin_backgrounds do
    member do
      get 'favorite'
    end
  end

  resources :interjections

  resources :my_colors

  resources :adjectives

  resources :animals

  resources :associates

  resources :organizations

  resources :roles

  resources :permissions

  resources :favorites do
    collection do
      get :add_to
      get :remove_from
    end
  end

  get "dashboard/index"
  resources :follow_up_types

  resources :follow_ups

  resources :contact_forms do
    member do
      get 'add_contact_type_to'
      get 'remove_contact_type_from'
    end
  end
  
  resources :contact_types

  resources :contacts do
    collection do
      post :create_multiple
      get :filter
      get :manage
      put :act_on_multiple
      put :multi_close
      put :export
      get :new_quick
      post :create_quick
      post :mass_create
    end
  end

  resources :comm_types

  resources :taggings do
    collection do
      get 'tag_group_selected'
    end
  end

  resources :tags

  resources :tag_groups

  resources :messages do
    collection do
      post 'receive'
    end
  end

  resources :envolvements
  resources :enrollments do
    member do
      get 'unenroll'
      get 'undo'
      get 're_enroll'
    end
  end

  resources :funds

  get 'contributions/search_person' => 'contributions#search_person', as: :search_person_contributions
  
  resources :contributions do
    collection do
      get 'enter'
      get 'find_person'
      get 'choose_person'
    end
  end

  resources :batches do
    member do
      get :breakout
    end
  end

  resources :smart_group_rules

  resources :smart_groups do
    collection do
      get 'property_selected'
    end
    member do
      get 'export'
      get 'export_by_household'
      get 'sms'
      get 'mass_contact'
    end
  end

  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions"}
  
  # admin namesapce...
  namespace :admin do
    resources :users do
      member do
        get 'confirm'
        get 'unconfirm'
      end
    end
    resources :groups do
      member do
        get 'convert'
      end
    end
  end
  
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
      get 'print_label'
      get 'self'
      get 'key_pressed'
      get 'search_self'
      get 'search_choice'
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

  resources :groups do
    member do
      get 'sms'
      get 'filter_enrollments'
      get 'email'
      get 'archive'
      get 'activate'
      get 'enroll'
      get 'search_people'
      get 'enroll_person'
      get 'export_people'
    end
    collection do
      get 'jump_to'
      get 'about'
    end
  end
  resources :small_groups
  resources :checkin_groups
  resources :lists

  resources :emails do
    collection do
      get 'setup'
      get 'send_out'
    end
  end

  resources :phones

  resources :people do
    member do
      get 'edit_image'
      get 'image_from_facebook'
      put 'update_image'
    end
    
    collection do
      get 'search'
    end
  end

  resources :households do
    member do
      get "map"
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: 'dashboard#index'

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
  get 'labels/:action' => 'labels#:action'
  get 'search/do' => 'search#do', :as => :do_search
  
end

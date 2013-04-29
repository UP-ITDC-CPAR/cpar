CparSystem::Application.routes.draw do

  root to: 'static_pages#home'
  
  get "users/new"
  match '/signup',  to: 'users#new'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets
  resources :email_verifications

  resources :issue_attachments, only: [:create, :destroy]
  resources :issue_comments, only: [:create, :destroy]
  resources :action_plan_comments, only: [:create, :destroy]
  resources :issue_comments, only: [:create, :destroy]
  resources :cause_comments, only: [:create, :destroy]

  resources :issues do
    get 'details', on: :member
    resources :causes
    get 'attach_form', on: :member
  end

  resources :action_plans do
    resources :activities
  end

  namespace :admin do
    get '', to: 'dashboard#index', as: '/'
    resources :users do
      get 'activate', on: :member
    end
  end

  namespace :qmr do
    get '', to: 'dashboard#index', as: '/'
    resources :next_responsible_departments, only: [:create, :destroy]
    resources :issues do 
      get 'statuschange', on: :member
      get 'details', on: :member
      get 'edit_departments', on: :member
      get 'sign_closeout', on: :member
      get 'notify_deadline', on: :member
    end
    resources :issue_comments, only: :create
  end

  namespace :auditor do
    get '', to: 'dashboard#index', as: '/'
    resources :action_plans do
      get 'review', :on => :member
      get 'reject', on: :member
      put 'update_activities', on: :member
      put 'update_activities2', on: :member
      get 'activity_statuschange', on: :member
      get 'implemented', on: :member
      get 'not_implemented', on: :member
    end
    resources :issues do
      get 'details', on: :member
      get 'sign_closeout', on: :member
    end
    resources :closeout_forms, only: :create
    resources :issue_comments, only: :create
    resources :action_plan_comments, only: :create
  end

  namespace :officer do
    get '', to: 'dashboard#index', as: '/'
    resources :action_plans do
      resources :activities do
        get 'mark_done', on: :member
      end
      get 'implemented', :on => :member
    end
    resources :issues do
      get 'details', on: :member
      get 'sign_closeout', on: :member
      resources :causes do
        post 'create_nrd', on: :collection
      end
    end
    resources :issue_comments, only: :create
    resources :action_plan_comments, only: :create
    resources :cause_comments, only: :create
    resources :cause_attachments, only: [:create, :destroy]
  end

  namespace :dept do
    get '', to: 'dashboard#index', as: '/'
    resources :users
    resources :issues do
      get 'details', on: :member
      get 'sign_closeout', on: :member
      get 'sign_closeout2', on: :member
      put 'update_date', on: :member
      resources :causes do
        post 'create_nrd', on: :collection
      end
    end
    resources :action_plans do
      resources :activities do
        get 'mark_done', on: :member
      end
      get 'implemented', :on => :member
    end
    resources :next_responsible_departments, only: :update
    resources :issue_comments, only: :create
    resources :action_plan_comments, only: :create
    resources :cause_comments, only: :create
    resources :cause_attachments, only: [:create, :destroy]
  end

  get "sessions/new"
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  #map.resources :action_plans do |action_plan|  
   # action_plan.resources :activities
  #end

  #get "action_plans/new"
  #get "action_plans/show"
  #get "action_plans/edit"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

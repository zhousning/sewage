Rails.application.routes.draw do
  root :to => 'controls#index'

  #mount Ckeditor::Engine => '/ckeditor'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'forget', to: 'admin/dashboard#index'
  #devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  devise_for :users, controllers: { sessions: 'users/sessions' }
  devise_scope :user do
    #get 'forget', to: 'users/passwords#forget'
    #patch 'update_password', to: 'users/passwords#update_password'
    #post '/login_validate', to: 'users/sessions#user_validate'
    #
    #unauthenticated :user do
    #  root to: "devise/sessions#new",as: :unauthenticated_root #设定登录页为系统默认首页
    #end
    #authenticated :user do
    #  root to: "homes#index",as: :authenticated_root #设定系统登录后首页
    #end
  end

  #resources :users, :only => []  do
  #  get :center, :on => :collection
  #  get :alipay_return, :on => :collection
  #  post :alipay_notify, :on => :collection
  #  get :mobile_authc_new, :on => :member
  #  post :mobile_authc_create, :on => :member
  #  get :mobile_authc_status, :on => :member
  #end

  resources :roles

  #resources :accounts, :only => [:edit, :update] do
  #  get :recharge, :on => :collection 
  #  get :info, :on => :collection
  #  get :status, :on => :collection
  #end

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :properties
  resources :nests 
  resources :domains 

  resources :controls, :only => [:index] do
    get :search, :on => :collection
  end
  resources :templates do
    get :produce, :on => :member
  end

  resources :nlps do
    collection do
      post 'analyze'
      get 'poem'
      post 'couplet'
    end
  end
  resources :ocrs do
    post :analyze, :on => :collection
  end

  resources :notices
  #resources :articles do
  #  get :export, :on => :collection
  #  get :main_image, :on => :member
  #  get :detail_image, :on => :member
  #end

  #resources :systems, :only => [] do
  #  get :send_confirm_code, :on => :collection
  #end
  #
  #resources :orders, :only => [:new, :create] do
  #  get :pay, :on => :collection
  #  get :alipay_return, :on => :collection
  #  post :alipay_notify, :on => :collection
  #end

  #resources :tasks, :only => [] do
  #  get :invite, :on => :collection
  #end

  #resources :spiders do
  #  get :start, :on => :member
  #end

  resources :selectors
 
  resources :factories, :only => [:edit, :update] do
    #get :bigscreen, :on => :member
    #resources :water_items do
    #  get :download_append, :on => :member
    #  get :update_count, :on => :member
    #  post :parse_excel, :on => :collection
    #  get :xls_download, :on => :collection
    #  get :query_all, :on => :collection
    #end
    resources :devices do
      get :download_append, :on => :member
      get :download_select, :on => :member
      get :download_update, :on => :member
      get :download_buy, :on => :member
      get :download_install, :on => :member
      get :download_dump, :on => :member
      get :download_accept, :on => :member

      post :parse_excel, :on => :collection
      get :xls_download, :on => :collection
      get :query_all, :on => :collection
      get :info, :on => :member
      get :uphold, :on => :member
    end
    resources :upholds do
      get :download_append, :on => :member
      get :query_all, :on => :collection
      get :query_devices, :on => :collection
    end
    #resources :projects do
    #  get :outbound, :on => :member
    #  resources :picks do
    #    get :completed, :on => :member
    #    get :canceled, :on => :member
    #    resources :pick_items do
    #      get :current_stock, :on => :collection
    #      get :select_stock, :on => :collection
    #      get :pick_item_create, :on => :collection
    #    end
    #  end
    #end

  end

  #resources :departments do
  #  get :download_append, :on => :member
  #  post :parse_excel, :on => :collection
  #  get :xls_download, :on => :collection
  #end
  resources :device_repairs do
    get :download_append, :on => :member
    get :xls_download, :on => :collection
    get :query_all, :on => :collection
  end
  resources :equipments, :only => [] do
    get :fcts, :on => :collection
    get :upholds, :on => :collection
    get :query_all, :on => :collection
  end
  resources :flower

end

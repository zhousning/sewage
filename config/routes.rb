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

  resources :wx_users, only: [:update] do
    collection do
      post 'get_userid'
      get 'fcts'
      get 'status'
      post 'set_fct'
    end
  end
  resources :wx_tasks, only: [] do
    collection do
      get 'query_all'
      get 'query_finish'
      get 'query_plan'
      get 'basic_card'
      get 'task_info'
      post 'report_create'
    end
  end
  resources :wx_task_logs, only: [] do
    collection do
      get 'task_start'
      get 'task_end'
      post 'accept_points'
    end
  end
  resources :wx_resources, only: [] do
    collection do
      post 'img_upload'
    end
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
      post :parse_excel, :on => :collection
      get :xls_download, :on => :collection
      get :query_all, :on => :collection
      get :info, :on => :member
      get :uphold, :on => :member
    end
    resources :tasks do
      get :xls_download, :on => :collection
      get :query_all, :on => :collection
      get :ongoing, :on => :member
      get :finish, :on => :member
    end
    resources :upholds do
      get :download_append, :on => :member
      get :query_all, :on => :collection
      get :query_devices, :on => :collection
    end
    resources :patrolers do
      get :download_append, :on => :member
      get :query_all, :on => :collection
      post :patroler_update, :on => :member
    end
    resources :inspectors, :only => [:index] do
      get :receive, :on => :member
      get :reject, :on => :member
    end

  end

  resources :equipments, :only => [] do
    get :fcts, :on => :collection
    get :upholds, :on => :collection
    get :query_all, :on => :collection
  end
  resources :tasks do
    get :download_append, :on => :member
    get :query_all, :on => :collection
  end
  resources :task_reports do
    get :download_append, :on => :member
    get :query_all, :on => :collection
  end
  resources :task_logs do
    get :download_append, :on => :member
    get :query_all, :on => :collection
  end
  resources :gdservices do
    resources :gdteminals do
    end
  end
  resources :gdteminals do
    resources :gdtraces do
    end
  end
  resources :flower

end

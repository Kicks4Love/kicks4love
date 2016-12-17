Rails.application.routes.draw do

  root :to => 'main#index'

  get '/features' => 'main#features'
  get '/oncourt' => 'main#oncourt'

  resources :main do
  	collection do
  		get 'get_posts'
  	end
  end

  get '/admin', :to => 'admin/dashboard#index', :as => :admin_root

  devise_for :admin_users, :controllers => {:sessions => 'admin/sessions'}, :skip => [:sessions]
  devise_scope :admin_user do
    get 'admin/login' => 'admin/sessions#new', :as => :new_admin_user_session
    post 'admin/login' => 'admin/sessions#create', :as => :admin_user_session
    delete 'admin/logout' => 'admin/sessions#destroy', :as => :destroy_admin_user_session
  end

  namespace :admin do
  	resources :posts
    resources :feature_posts
    resources :on_court_posts
    resources :admin_users
  end

end
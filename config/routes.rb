Rails.application.routes.draw do

  devise_for :admin_users
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
      get 'admin/login' => 'admin/sessions#new'
      post 'admin/login' => 'admin/sessions#create'
      delete 'admin/logout' => 'admin/sessions#destroy'
    end

  	namespace :admin do
  		resources :posts
      resources :feature_posts
      resources :on_court_posts
  	end

end
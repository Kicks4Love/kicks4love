Rails.application.routes.draw do

  root :to => 'main#index'

  get '/features' => 'main#features'
  get '/features/:id' => 'main#feature_show'
  get '/calendar' => 'main#calendar'
  get '/trend' =>'main#trend'
  get '/trend/:id' => 'main#trend_show'
  get '/oncourt' => 'main#oncourt'
  get '/oncourt/:id' => 'main#oncourt_show'

  resources :main do
  	collection do
  		get 'get_posts'
      post 'change_language'
  	end
  end

  get '/admin', :to => 'admin/dashboard#index', :as => :admin_root

  devise_for :admin_users, :controllers => {:sessions => 'admin/sessions', :registrations => "admin/registrations"}, :skip => [:sessions, :registrations]
  devise_scope :admin_user do
    get 'admin/login' => 'admin/sessions#new', :as => :new_admin_user_session
    post 'admin/login' => 'admin/sessions#create', :as => :admin_user_session
    delete 'admin/logout' => 'admin/sessions#destroy', :as => :destroy_admin_user_session
    get 'admin/register' => 'admin/registrations#new', :as => :new_admin_user_registration
    post 'admin/register' => 'admin/registrations#create', :as => :admin_user_registration
    get 'admin/register/:id/edit' => 'admin/registrations#edit', :as => :edit_admin_user_registration
    put 'admin/register' => 'admin/registrations#update'
  end

  namespace :admin do
  	resources :posts do
      collection do
        get 'get_posts'
      end
    end
    resources :feature_posts do
      collection do
        delete 'remove_old'
      end
    end
    resources :calendar_posts do
      collection do
        delete 'remove_old'
      end
    end
    resources :trend_posts do
      collection do
        delete 'remove_old'
      end
    end
    resources :on_court_posts do
      collection do
        delete 'remove_old'
      end
    end
    resources :admin_users
  end

end

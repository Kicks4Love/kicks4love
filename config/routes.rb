Rails.application.routes.draw do

  root :to => 'main#index'

  get '/features' => 'main#features'
  get '/features/:id' => 'main#feature_show'
  get '/calendar' => 'main#calendar'
  get '/trend' =>'main#trend'
  get '/trend/:id' => 'main#trend_show'
  get '/oncourt' => 'main#oncourt'
  get '/oncourt/:id' => 'main#oncourt_show'
  get '/streetsnap' => 'main#streetsnap'
  get '/streetsnap/:id' => 'main#streetsnap_show'
  get '/rumors' => 'main#rumors'
  get '/rumors/:id' => 'main#rumor_show'
  get '/privacy' => 'main#privacy'
  get '/contact_us' => 'main#contact'
  get '/search' => 'main#search'

  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  resources :main do
  	collection do
  		get 'get_posts'
      post 'change_language'
      post 'send_contact_us'
      post 'post_rating'
      post 'subscribe'
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
        post 'send_newsletter'
      end
      member do
        delete 'delete_subscriber'
      end
    end
    resources :feature_posts do
      collection do
        get 'remove_old'
      end
    end
    resources :calendar_posts do
      collection do
        get 'remove_old'
      end
    end
    resources :trend_posts do
      collection do
        get 'remove_old'
      end
    end
    resources :on_court_posts do
      collection do
        get 'remove_old'
      end
    end
    resources :rumor_posts do
      collection do
        get 'remove_old'
      end
    end
    resources :street_snap_posts do
      collection do
        get 'remove_old'
      end
    end
    resources :admin_users
  end

  get '/sitemap.xml', :to => 'sitemap#index', :defaults => {:format => 'xml'}

  namespace :api do
    scope :v0 do
      scope :home_posts do
        get '/' => 'home_posts#index'
      end
      scope :featured_posts do
        get '/' => 'featured_posts#index'
        get '/:id' => 'featured_posts#show'
      end
      scope :oncourt_posts do
        get '/' => 'oncourt_posts#index'
        get '/:id' => 'oncourt_posts#show'
      end
      scope :trend_posts do
        get '/' => 'trend_posts#index'
        get '/:id' => 'trend_posts#show'
      end
      scope :streetsnap_posts do
        get '/' => 'streetsnap_posts#index'
        get '/:id' => 'streetsnap_posts#show'
      end
      scope :rumor_posts do
        get '/' => 'rumor_posts#index'
        get '/:id' => 'rumor_posts#show'
      end
    end
  end

end

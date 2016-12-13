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

  	namespace :admin do
  		resources :posts
      resources :feature_posts
      resources :on_court_posts
  	end

end

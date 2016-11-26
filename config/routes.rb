Rails.application.routes.draw do
  	
  	root :to => 'main#index'

    get '/features' => 'main#features'

  	resources :main do
  		collection do 
  			get 'get_posts'
  		end
  	end

  	get '/admin', :to => 'admin/dashboard#index', :as => :admin_root

  	namespace :admin do
  		resources :posts
      resources :feature_posts
  	end

end

Rails.application.routes.draw do
  	
  	root :to => 'main#index'

  	resources :main, :path => '', :only => [:features] do
  		collection do 
        get 'features'
  			get 'get_posts'
  		end
  	end

  	get '/admin/', :to => 'admin/dashboard#index', :as => :admin_root

  	namespace :admin do
  		resources :posts
      resources :feature_posts
  	end

end

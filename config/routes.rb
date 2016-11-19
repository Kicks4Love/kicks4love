Rails.application.routes.draw do
  	
  	root :to => "main#index"

  	resources :main

  	get '/admin/', :to => 'admin/dashboard#index', :as => :admin_root

  	namespace :admin do
  		resources :posts
  	end

end

Rails.application.routes.draw do
  	
  	root :to => "main#index"

  	resources :main

  	namespace :admin do
  		resources :posts
  	end

end

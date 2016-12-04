Rails.application.routes.draw do

  # namespace :admin do
  #   get 'on_court_posts/index'
  # end
  #
  # namespace :admin do
  #   get 'on_court_posts/show'
  # end
  #
  # namespace :admin do
  #   get 'on_court_posts/new'
  # end
  #
  # namespace :admin do
  #   get 'on_court_posts/edit'
  # end

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
      resources :on_court_posts
  	end

end

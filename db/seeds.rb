Rails.application.routes.draw do
  devise_for :users

  # Authentication
  post '/users/login', to: 'sessions#create'
  post '/users', to: 'sessions#register'

  # User profile
  get '/profiles/:username', to: 'users#show'
  put '/user', to: 'users#update'

  # Articles
  resources :articles, param: :slug do
    resources :comments, only: [ :index, :create, :destroy ]
  end

  # Tags
  resources :tags, only: [ :index ]
end

Rails.application.routes.draw do
  devise_for :users, skip: :all

  post "/users/login", to: "sessions#create"
  post "/users", to: "sessions#register"

  get "/profiles/:username", to: "users#show"
  put "/user", to: "users#update"

  resources :articles, param: :slug do
    resources :comments, only: [ :index, :create, :destroy ]
  end

  resources :tags, only: [ :index ]
end

Qa::Application.routes.draw do
  root to: 'questions#index'

  resources :users, only: [:create]
  get '/login', to: 'sessions#new'
  get '/signup', to: 'users#new'
  match '/auth/:provider/callback', to: 'authorizations#callback'
end
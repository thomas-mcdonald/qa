Qa::Application.routes.draw do
  resources :users, only: [:create]
  get '/login', to: 'sessions#new'
  get '/signup', to: 'users#new'
  match '/auth/:provider/callback', to: 'authorizations#callback'
end
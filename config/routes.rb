Qa::Application.routes.draw do
  resources :users, only: [:create]
  get '/signup', to: 'users#new'
  match '/auth/:provider/callback', to: 'authorizations#callback'
end
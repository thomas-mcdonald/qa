Qa::Application.routes.draw do
  root to: 'questions#index'
  get '/ask', to: 'questions#new', as: 'new_question'
  get '/questions/new' => redirect('/ask')
  get '/questions/tagged/:tag', to: 'questions#tagged'
  get '/questions/:id/:slug', to: 'questions#show'
  patch '/questions/:id/:slug', to: 'questions#update'
  get '/questions/:id/:slug/edit', to: 'questions#edit', as: 'edit_question'
  resources :questions, only: [:create, :show]

  resources :answers, only: [:create, :edit, :update]
  resources :votes, only: [:create, :destroy]

  get '/users/:id/:slug', to: 'users#show'
  resources :users, only: [:create, :show]
  get '/login', to: 'sessions#new'
  post '/logout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'
  # omniauth callbacks
  get '/auth/:provider/callback', to: 'authorizations#callback'
  post '/auth/:provider/callback', to: 'authorizations#callback'

  # development routes
  if Rails.env.development?
    get '/dev/login', to: 'dev#login'
  end
end
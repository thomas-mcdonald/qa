Qa::Application.routes.draw do
  root to: 'questions#index'
  get '/ask', to: 'questions#new', as: 'new_question'
  get '/questions/new' => redirect('/ask')
  resources :questions, only: [:create, :show]

  resources :users, only: [:create]
  get '/login', to: 'sessions#new'
  get '/signup', to: 'users#new'
  match '/auth/:provider/callback', to: 'authorizations#callback'
end
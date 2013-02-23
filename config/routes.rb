Qa::Application.routes.draw do
  root to: 'questions#index'
  get '/ask', to: 'questions#new', as: 'new_question'
  get '/questions/new' => redirect('/ask')
  get '/questions/:id/:slug', to: 'questions#show'
  put '/questions/:id/:slug', to: 'questions#update'
  get '/questions/:id/:slug/edit', to: 'questions#edit', as: 'edit_question'
  resources :questions, only: [:create, :show]

  get '/users/:id/:slug', to: 'users#show'
  resources :users, only: [:create, :show]
  get '/login', to: 'sessions#new'
  get '/signup', to: 'users#new'
  match '/auth/:provider/callback', to: 'authorizations#callback'
end
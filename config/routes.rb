require 'sidekiq/web'

class AdminConstraint
  def matches?(request)
    return false unless request.session[:user_id]
    user = User.find(request.session[:user_id])
    user && user.admin?
  end
end

QA::Application.routes.draw do
  mount Sidekiq::Web => '/admin/sidekiq', constraints: AdminConstraint.new

  root to: 'questions#index'

  # Question URLs
  get '/ask', to: 'questions#new', as: 'new_question'
  get '/questions/new' => redirect('/ask')
  get '/questions/tagged/:tag', to: 'questions#tagged', as: 'questions_tagged'
  get '/questions/:id/:slug', to: 'questions#show'
  resources :questions, only: [:create, :show]

  # Shorter URLs where slugs don't matter
  patch '/q/:id', to: 'questions#update', as: 'update_question'
  get '/q/:id/edit', to: 'questions#edit', as: 'edit_question'
  post '/q/:id/accept', to: 'questions#accept_answer', as: 'accept_answer'

  resources :answers, only: [:create, :edit, :update]
  resources :votes, only: [:create, :destroy]

  get '/users/:id/:slug', to: 'users#show'
  resources :users, only: [:create, :show]
  get '/login', to: 'sessions#new', as: 'login'
  post '/logout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'
  # omniauth callbacks
  get '/auth/:provider/callback', to: 'authorizations#callback'
  post '/auth/:provider/callback', to: 'authorizations#callback'

  get '/tags', to: 'tags#index'

  # development routes
  if Rails.env.development?
    get '/dev/login', to: 'dev#login'
  end
end
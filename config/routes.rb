require 'sidekiq/web'

class AdminConstraint
  def matches?(request)
    return false unless request.session[:user_id]
    user = User.find(request.session[:user_id])
    user && user.admin?
  end
end

QA::Application.routes.draw do
  root to: 'questions#index'

  # Question URLs
  get '/ask', to: 'questions#new', as: 'new_question'
  get '/questions/new' => redirect('/ask')
  get '/questions/tagged/:tag', to: 'questions#tagged', as: 'questions_tagged'
  resources :questions, only: [:create, :show]

  # Shorter URLs where slugs don't matter
  patch '/q/:id', to: 'questions#update', as: 'update_question'
  get '/q/:id/edit', to: 'questions#edit', as: 'edit_question'
  get '/q/:id/timeline', to: 'questions#timeline', as: 'question_timeline'
  post '/q/:id/accept', to: 'questions#accept_answer', as: 'accept_answer'
  post '/q/:id/unaccept', to: 'questions#unaccept_answer', as: 'unaccept_answer'

  resources :answers, only: [:create, :edit, :update]
  get '/a/:id/timeline', to: 'answers#timeline', as: 'answer_timeline'

  resources :badges, only: [:show]
  resources :comments, only: [:new, :create]
  resources :votes, only: [:create, :destroy]

  get '/user/edit', to: 'users#edit', as: 'edit_user'
  resources :users, only: [:index, :show, :create, :update] do
    member do
      get 'answers'
      get 'questions'
    end
  end
  post '/logout', to: 'sessions#destroy'

  # omniauth callbacks
  get '/auth/:provider/callback', to: 'authorizations#callback'
  post '/auth/:provider/callback', to: 'authorizations#callback'

  get '/tags', to: 'tags#index'
  get '/tags/search', to: 'tags#search'

  constraints AdminConstraint.new do
    namespace :admin do
      resources :users, only: [:edit, :update]
      get '/', to: 'dashboard#index'
      get '/health', to: 'dashboard#health'
    end

    mount PgHero::Engine, at: '/admin/pghero'
    mount Sidekiq::Web, at: '/admin/sidekiq'
  end

  # development routes
  if Rails.env.development?
    get '/dev/login', to: 'dev#login'
  end
end

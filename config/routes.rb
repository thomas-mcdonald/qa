Qa::Application.routes.draw do
  root :to => 'questions#index'

  resources :questions do
    resources :flags, :only => [:new, :create]

    collection do
      get 'tagged/:tag', :action => :tagged, :as => :tagged
    end
    member do
      get 'revisions'
    end
    resources :answers, :only => [:create] do
      member do
        get 'revisions'
      end
    end
  end

  # Avoid nesting answer routes under question
  resources :answers, :only => [:edit, :update] do
    resources :flags, :only => [:new, :create]
  end

  resources :flags, :only => [:index] do
    member do
      get 'dismiss'
    end
  end

  resources :badges, :only => [:index, :show]
  get '/notifications/:id/dismiss' => 'notifications#dismiss'
  resources :tags, :only => [:index]
  resources :votes, :only => [:create, :destroy]

  match 'user/edit' => 'users#edit', :as => :edit_current_user
  match 'signup' => 'users#new', :as => :signup
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login

  resources :sessions, :only => [:create]
  resources :users, :except => [:destroy, :edit]
end

Qa::Application.routes.draw do
  root :to => 'questions#index'

  resources :questions do
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

  resources :badges, :only => [:index, :show]
  resources :tags, :only => [:index]
  resources :votes, :only => [:create, :destroy]

  match 'user/edit' => 'users#edit', :as => :edit_current_user
  match 'signup' => 'users#new', :as => :signup
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login

  resources :sessions, :only => [:create]
  resources :users, :except => [:destroy, :edit]
end

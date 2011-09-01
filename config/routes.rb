Qa::Application.routes.draw do
  root :to => 'questions#index'

  resources :questions do
    collection do
#      resources :tags, :only => [:show], :path => "tagged"
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
  resources :tags, :only => [:index, :show]
  resources :votes, :only => [:create, :destroy]

  match 'user/edit' => 'users#edit', :as => :edit_current_user
  match 'signup' => 'users#new', :as => :signup
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login
  match 'tag/autocomplete' => 'questions#tag_autocomplete'

  resources :sessions, :only => [:create]
  resources :users, :except => [:destroy, :edit]
end

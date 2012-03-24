Qa::Application.routes.draw do
  get '/signup', to: 'users#new'
  match '/auth/:provider/callback', to: 'users#confirm'
end
Qa::Application.routes.draw do
  get '/signup', to: 'users#new'
  get '/auth/:provider/callback', to: 'users#confirm'
end
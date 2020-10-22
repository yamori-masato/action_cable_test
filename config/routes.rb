Rails.application.routes.draw do
  get '/login', to: 'session#new'
  post '/login', to: 'session#create'
  delete '/logout', to: 'session#destroy'


  root to: 'users#show'
  # get '/rooms/show/:id', to: 'room#show'
  resources :rooms

  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

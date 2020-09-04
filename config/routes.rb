Rails.application.routes.draw do


  resources :items
  
  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help' 
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/items/new', to: 'items#new'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  post '/users/verify' => "users#verify"
  post   '/items',    to: 'items#new'
  post  '/items/buy',  to: 'items#buy'
  post  '/users/profilefeed', to: 'users#profilefeed'
  post  '/items/purchase', to: 'items#purchase'
  post  '/static_pages/home', to: 'static_pages#home'
  post  '/static_pages/homefeed', to: 'static_pages#homefeed'
  get    '/search' => 'static_pages#search', :as => 'search_page'
  get   '/users/sendotp',  to:  'users#sendotp'
  get   '/users/OTPverifypage',  to:  'users#OTPverifypage'
  post  '/users/show', to: 'users#show'

  resources :users


  
end

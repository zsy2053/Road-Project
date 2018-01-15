Rails.application.routes.draw do
  post 'login' => 'authentication#authenticate_user'
  devise_for :users
  resources :stations
  resources :contracts
  resources :sites
  resources :road_orders, only: [:index, :show, :create]
  resources :uploads, only: [:show, :create]

  post 'password/forgot', to: 'passwords#forgot'
  post 'password/reset', to: 'passwords#reset'
end

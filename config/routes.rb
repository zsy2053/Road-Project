Rails.application.routes.draw do
  post 'login' => 'authentication#authenticate_user'
  devise_for :users
  resources :users
  resources :stations
  resources :contracts
  resources :sites, only: [:index]
  resources :road_orders, only: [:index, :show, :create]
  resources :uploads, only: [:show, :create]
  resources :accesses, only: [:create, :destroy]
  post 'accesses/multi_update', to: 'accesses#multi_update'
  resources :back_orders, only: [:index, :show, :create]

  resources :transfer_orders, only: [:index, :show]
  post 'transfer_orders/', to: 'transfer_orders#create_or_update'

  post 'password/forgot', to: 'passwords#forgot'
  post 'password/reset', to: 'passwords#reset'
end

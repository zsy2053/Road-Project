Rails.application.routes.draw do
  post 'login' => 'authentication#authenticate_user'
  devise_for :users
  resources :users
  resources :stations do
    resources :back_orders, only: [:index]
  end
  resources :contracts
  resources :sites, only: [:index]
  resources :road_orders, only: [:index, :show, :create]
  resources :uploads, only: [:show, :create]
  resources :accesses, only: [:create, :destroy]
  post 'accesses/multi_update', to: 'accesses#multi_update'
  resources :back_orders, only: [:index, :show, :create]

  resources :transfer_orders, only: [:index, :show]
  post 'transfer_orders/', to: 'transfer_orders#create_or_update'

  resources :car_road_orders, only: [:index, :create, :show]

  resources :works, only: [:index, :create, :show]
  resources :stop_reasons, only: [:index, :show]
  resources :operators, only: [:index, :show, :create, :update]
  resources :movements, only: [:show, :update]
  resources :positions, only: [:show, :update]

  get 'operators/showbadge/:badge', to: 'operators#showbadge'

  post 'password/forgot', to: 'passwords#forgot'
  post 'password/reset', to: 'passwords#reset'
  get 'token/verify', to: 'passwords#verify'
end

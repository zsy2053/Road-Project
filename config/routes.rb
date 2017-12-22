Rails.application.routes.draw do
  post 'login' => 'authentication#authenticate_user'
  devise_for :users
  resources :stations
  resources :contracts
  resources :sites
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  resources :stations
  resources :contracts
  resources :sites
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

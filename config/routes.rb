Rails.application.routes.draw do
  resources :heartbeat, only: [:index]
  resources :events, only: [:index, :create, :update]
end

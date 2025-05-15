# frozen_string_literal: true

Rails.application.routes.draw do
  resources :heartbeat, only: [:index]
  resources :events, only: [:index]
end

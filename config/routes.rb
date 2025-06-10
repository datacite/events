# frozen_string_literal: true

Rails.application.routes.draw do
  get "heartbeat", to: "heartbeat#index"

  root to: "heartbeat#index"
end

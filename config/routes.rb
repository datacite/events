# frozen_string_literal: true

Rails.application.routes.draw do
  get "heartbeat", to: "heartbeat#index"

  root to: "heartbeat#index"

  get "enriched-doi/*doi", to: "enrichments#doi", constraints: { id: /.+/ }, format: false
  get "enriched-dois", to: "enrichments#dois", constraints: { id: /.+/ }, format: false
end

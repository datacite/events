# frozen_string_literal: true

Rails.application.routes.draw do
  get "heartbeat", to: "heartbeat#index"

  root to: "heartbeat#index"

  get "doi/*doi", to: "enrichments#doi", constraints: { id: /.+/ }
  get "dois", to: "enrichments#dois", constraints: { id: /.+/ }
end

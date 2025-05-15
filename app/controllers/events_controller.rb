# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    message = { data: { action: "events#index" } }

    render(json: message)
  end
end

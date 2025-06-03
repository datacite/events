# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    Rails.logger.info("EventsController#index called")
    Rails.logger.info("EventsController#index testing logging")
    message = { data: { action: "events#index" } }

    render(json: message)
  end
end

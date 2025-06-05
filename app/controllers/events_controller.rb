# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    Rails.logger.info("Events Production Logging Test Start")
    Rails.logger.info("EventsController#index called")
    Rails.logger.info("Events Production Logging Test End")

    Rails.logger.info("Events Production MySql Test Start")
    event = Event.first
    Rails.logger.info("No event found") if event.blank?
    Rails.logger.info("Event found: #{event.uuid}")
    Rails.logger.info("Events Production MySql Test End")

    Rails.logger.info("Events Production Sentry Test Start")
    Sentry.capture_message("EventsController#index Sentry Test")
    Rails.logger.info("Events Production Sentry Test End")

    Rails.logger.info("Events Production OpenSearch Test Start")
    Rails.logger.info(Elasticsearch::Model.client.info.inspect)
    Rails.logger.info("Events Production OpenSearch Test End")

    message = { data: { action: "events#index" } }

    render(json: message)
  end
end

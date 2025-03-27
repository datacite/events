# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    attributes = {
      id: 1,
      uuid: "new_uuid",
      created_at: Time.now.utc,
    }
    Factories::EventFactory.create_instance(attributes)
    event = Event.new
    event.attributes = {
      id: 1,
      uuid: "new_uuid",
      created_at: Time.now.utc,
    }
    data = {
      body: event,
      id: event.id,
      uuid: event.uuid,
      created_at: event.created_at,
    }
    render(json: { data: data })
  end

  def create
    render(json: { message: "create" })
  end

  def update
    render(json: { message: "update" })
  end
end

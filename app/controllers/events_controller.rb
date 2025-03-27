# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    attributes = {
      id: 1,
      uuid: "new_uuid",
      created_at: Time.now.utc,
    }
    event = Event.new(attributes)
    render(json: { data: event })
  end

  def create
    render(json: { message: "create" })
  end

  def update
    render(json: { message: "update" })
  end
end

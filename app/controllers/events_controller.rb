# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    render(json: { data: Elasticsearch::Model.client.info })
  end

  def create
    render(json: { message: "create" })
  end

  def update
    render(json: { message: "update" })
  end
end

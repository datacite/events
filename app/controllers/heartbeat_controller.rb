# frozen_string_literal: true

class HeartbeatController < ApplicationController
  def index
    message = { data: { healthy: true } }

    render(json: message)
  end
end

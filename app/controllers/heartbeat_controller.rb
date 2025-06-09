# frozen_string_literal: true

class HeartbeatController < ApplicationController
  def index
    render(
      plain: "OK",
      status: :ok,
      content_type: "text/plain",
    )
  end
end

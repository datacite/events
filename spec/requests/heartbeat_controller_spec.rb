# frozen_string_literal: true

require "rails_helper"

RSpec.describe(HeartbeatController, type: :request) do
  describe "GET /index" do
    it "returns a 200 status code" do
      get "/heartbeat"

      expect(response).to(have_http_status(:ok))
    end

    it "returns json" do
      get "/heartbeat"

      expect(response.content_type).to(eq("text/plain; charset=utf-8"))
    end

    it "returns the expected data" do
      get "/heartbeat"

      expect(response.body).to(eq("OK"))
    end
  end
end

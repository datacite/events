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

      expect(response.content_type).to(eq("application/json; charset=utf-8"))
    end

    it "returns the expected data" do
      get "/heartbeat"

      expected = { data: { healthy: true } }

      expect(JSON.parse(response.body, symbolize_names: true)).to(eq(expected))
    end
  end
end

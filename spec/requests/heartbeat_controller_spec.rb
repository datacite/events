# frozen_string_literal: true

require "rails_helper"

RSpec.describe("HeartbeatControllers", type: :request) do
  describe "GET /index" do
    it "returns a 200 status code" do
      get "/heartbeat"
      expect(response).to(have_http_status(200))
    end

    it "returns json" do
      get "/heartbeat"
      expect(response.content_type).to(eq("application/json; charset=utf-8"))
    end

    it "retrurns the expected data" do
      get "/heartbeat"
      expect(JSON.parse(response.body, symbolize_names: true)).to(eq({ healthy: true }))
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe("HeartbeatControllers", type: :request) do
  describe "GET /index" do
    before do
      get "/heartbeat"
    end

    it "returns a 200 status code" do
      expect(response).to(have_http_status(200))
    end

    it "returns json" do
      expect(response.content_type).to(eq("application/json"))
    end

    it "retrurns the expected data" do
      expect(JSON.parse(response.body)).to(eq({ message: "healthy" }))
    end
    # get "/heartbeat"

    # expect(response).to have_http_status(200)
    # expect(response.content_type).to eq("application/json")
    # expect(JSON.parse(response.body)).to eq({message: "healthy"})
  end
end

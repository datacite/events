# frozen_string_literal: true

require "rails_helper"

RSpec.describe(EventsController, type: :request) do
  describe "GET /index" do
    it "returns a 200 status code" do
      get "/events"

      expect(response).to(have_http_status(:ok))
    end

    it "returns json" do
      get "/events"

      expect(response.content_type).to(eq("application/json; charset=utf-8"))
    end

    it "returns the expected data" do
      get "/events"

      expected = { data: { action: "events#index" } }

      expect(JSON.parse(response.body, symbolize_names: true)).to(eq(expected))
    end
  end
end

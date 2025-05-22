# frozen_string_literal: true

require "rails_helper"

RSpec.describe(EventIndexHandler, type: :concern) do
  include ActiveSupport::Testing::TimeHelpers

  describe ".subj_cache_key" do
    it "when subj_hash has 'dateModified' returns expected result" do
      event = build(:event)
      event.subj_id = "00.0000/zenodo.00000000"
      event.subj = { "dateModified": "2025-01-01 00:00:00" }.to_json

      expect(event.subj_cache_key).to(eq("objects/00.0000/zenodo.00000000-2025-01-01 00:00:00"))
    end

    it "when subj_hash does not have a 'dateModified' returns expected result" do
      travel_to(Time.zone.parse("2025-01-01T00:00:00Z")) do
        event = build(:event)
        event.subj_id = "00.0000/zenodo.00000000"
        event.subj = { "key": "value" }.to_json

        expect(event.subj_cache_key).to(eq("objects/00.0000/zenodo.00000000-2025-01-01T00:00:00Z"))
      end
    end
  end

  describe ".obj_cache_key" do
    it "when obj_hash has 'dateModified' returns expected result" do
      event = build(:event)
      event.obj_id = "00.0000/zenodo.00000000"
      event.obj = { "dateModified": "2025-01-01 00:00:00" }.to_json

      expect(event.obj_cache_key).to(eq("objects/00.0000/zenodo.00000000-2025-01-01 00:00:00"))
    end

    it "when obj_hash does not have a 'dateModified' returns expected result" do
      travel_to(Time.zone.parse("2025-01-01T00:00:00Z")) do
        event = build(:event)
        event.obj_id = "00.0000/zenodo.00000000"
        event.obj = { "key": "value" }.to_json

        expect(event.obj_cache_key).to(eq("objects/00.0000/zenodo.00000000-2025-01-01T00:00:00Z"))
      end
    end
  end
end

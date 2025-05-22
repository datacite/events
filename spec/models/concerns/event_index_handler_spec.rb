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

  describe ".doi" do
    let(:proxy_identifiers) { ["00.0000/zenodo.0000", "01.0001/zenodo.0001"] }
    let(:event) { build(:event) }

    describe "when dois are valid" do
      it "when subj_hash has 'proxyIdentifiers' adds to doi" do
        event.subj_id = nil
        event.obj_id = nil
        event.subj = { "proxyIdentifiers": ["10.0000/zenodo.0000", "10.0000/zenodo.0001"] }.to_json

        expect(event.doi).to(eq(["10.0000/zenodo.0000", "10.0000/zenodo.0001"]))
      end

      it "when obj_hash has 'proxyIdentifiers' adds to doi" do
        event.subj_id = nil
        event.obj_id = nil
        event.obj = { "proxyIdentifiers": ["10.0000/zenodo.0000", "10.0000/zenodo.0001"] }.to_json

        expect(event.doi).to(eq(["10.0000/zenodo.0000", "10.0000/zenodo.0001"]))
      end

      it "when subj_hash has 'funder' adds to doi" do
        funders = [{ "@id" => "10.0000/zenodo.0000" }, { "@id" => "10.0001/zenodo.0001" }]
        event.subj_id = nil
        event.obj_id = nil
        event.subj = { "funder": funders }.to_json

        expect(event.doi).to(eq(["10.0000/zenodo.0000", "10.0001/zenodo.0001"]))
      end

      it "when obj_hash has 'funder' adds to doi" do
        funders = [{ "@id" => "10.0000/zenodo.0000" }, { "@id" => "10.0001/zenodo.0001" }]
        event.subj_id = nil
        event.obj_id = nil
        event.obj = { "funder": funders }.to_json

        expect(event.doi).to(eq(["10.0000/zenodo.0000", "10.0001/zenodo.0001"]))
      end

      it "when subj_id is valid adds to doi" do
        event.subj_id = "10.0000/zenodo.0000"
        event.obj_id = nil

        expect(event.doi).to(eq(["10.0000/zenodo.0000"]))
      end

      it "when obj_id is valid adds to doi" do
        event.obj_id = "10.0000/zenodo.0000"
        event.subj_id = nil

        expect(event.doi).to(eq(["10.0000/zenodo.0000"]))
      end
    end
  end
end

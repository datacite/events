# frozen_string_literal: true

require "rails_helper"

RSpec.describe(EventIndexHandler, type: :concern) do
  include ActiveSupport::Testing::TimeHelpers

  describe ".subj_cache_key" do
    it "when subj_hash has 'dateModified' returns expected result" do
      event = Event.new(
        subj_id: "00.0000/zenodo.00000000",
        subj: {
          "@id" => "00.0000/zenodo.00000000",
          "@type" => "Organization",
          "name" => "DataCite",
          "dateModified" => "2025-01-01 00:00:00",
          "location" => {
            "type" => "postalAddress",
            "addressCountry" => "Germany",
          },
        }.to_json,
      )

      expected = "objects/00.0000/zenodo.00000000-2025-01-01 00:00:00"

      expect(event.subj_cache_key).to(eq(expected))
    end

    it "when subj_hash does not have a 'dateModified' returns expected result" do
      travel_to(Time.zone.parse("2025-01-01T00:00:00Z")) do
        event = Event.new(
          subj_id: "00.0000/zenodo.00000000",
          subj: { "field": "value" }.to_json,
        )

        expected = "objects/00.0000/zenodo.00000000-2025-01-01T00:00:00Z"

        expect(event.subj_cache_key).to(eq(expected))
      end
    end
  end

  describe ".obj_cache_key" do
    it "when obj_hash has 'dateModified' returns expected result" do
      event = Event.new(
        obj_id: "00.0000/zenodo.00000000",
        obj: {
          "@id" => "00.0000/zenodo.00000000",
          "@type" => "Organization",
          "name" => "DataCite",
          "dateModified" => "2025-01-01 00:00:00",
          "location" => {
            "type" => "postalAddress",
            "addressCountry" => "Germany",
          },
        }.to_json,
      )

      expected = "objects/00.0000/zenodo.00000000-2025-01-01 00:00:00"

      expect(event.obj_cache_key).to(eq(expected))
    end

    it "when obj_hash does not have a 'dateModified' returns expected result" do
      travel_to(Time.zone.parse("2025-01-01T00:00:00Z")) do
        event = Event.new(
          obj_id: "00.0000/zenodo.00000000",
          obj: { "field": "value" }.to_json,
        )

        expected = "objects/00.0000/zenodo.00000000-2025-01-01T00:00:00Z"

        expect(event.obj_cache_key).to(eq(expected))
      end
    end
  end
end

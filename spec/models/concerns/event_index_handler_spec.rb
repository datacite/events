# frozen_string_literal: true

require "rails_helper"

RSpec.describe(EventIndexHandler, type: :concern) do
  include ActiveSupport::Testing::TimeHelpers

  let(:event) { build(:event) }

  describe ".as_indexed_json" do
    before do
      event.relation_type_id = "cites"
    end

    it "returns a hash with the correct keys" do
      expect(event.as_indexed_json).to(include(
        "uuid",
        "subj_id",
        "obj_id",
        "subj",
        "obj",
        "source_doi",
        "target_doi",
        "source_relation_type_id",
        "target_relation_type_id",
        "doi",
        "orcid",
        "issn",
        "prefix",
        "subtype",
        "citation_type",
        "source_id",
        "source_token",
        "message_action",
        "relation_type_id",
        "registrant_id",
        "access_method",
        "metric_type",
        "total",
        "license",
        "error_messages",
        "aasm_state",
        "state_event",
        "year_month",
        "created_at",
        "updated_at",
        "indexed_at",
        "occurred_at",
        "citation_id",
        "citation_year",
        "cache_key",
      ))
    end

    it "returns a response with the correct 'uuid'" do
      event.set_source_and_target_doi!

      expect(event.as_indexed_json["uuid"]).to(eq("00000000-0000-0000-0000-000000000000"))
    end

    it "returns a response with the correct 'subj_id'" do
      event.set_source_and_target_doi!

      expect(event.as_indexed_json["subj_id"]).to(eq("10.0000/subj.id"))
    end

    it "returns a response with the correct obj_id" do
      event.set_source_and_target_doi!

      expect(event.as_indexed_json["obj_id"]).to(eq("10.0000/obj.id"))
    end

    it "returns a response with the correct 'subj'" do
      allow(event).to(receive(:subj_cache_key).and_return("fake-cache-key"))

      subj = { "@id" => "10.0000/subj.id", "dateModified" => "2025-01-01 00:00:00" }

      event.subj = subj.to_json

      event.set_source_and_target_doi!

      expected = subj.merge("cache_key" => "fake-cache-key")

      expect(event.as_indexed_json["subj"]).to(eq(expected))
    end

    it "returns a response with the correct 'obj'" do
      allow(event).to(receive(:obj_cache_key).and_return("fake-cache-key"))

      obj = { "@id" => "10.0000/obj.id", "dateModified" => "2025-01-01 00:00:00" }

      event.obj = obj.to_json

      event.set_source_and_target_doi!

      expected = obj.merge("cache_key" => "fake-cache-key")

      expect(event.as_indexed_json["obj"]).to(eq(expected))
    end

    it "returns a response with the correct 'source_doi'" do
      event.set_source_and_target_doi!

      expect(event.as_indexed_json["source_doi"]).to(eq("10.0000/SUBJ.ID"))
    end

    it "returns a response with the correct 'target_doi'" do
      event.set_source_and_target_doi!

      expect(event.as_indexed_json["target_doi"]).to(eq("10.0000/OBJ.ID"))
    end

    it "returns a response with the correct 'source_relation_type_id'" do
      event.set_source_and_target_doi!

      expect(event.as_indexed_json["source_relation_type_id"]).to(eq("references"))
    end

    it "returns a response with the correct 'target_relation_type_id'" do
      event.set_source_and_target_doi!

      expect(event.as_indexed_json["target_relation_type_id"]).to(eq("citations"))
    end

    it "returns a response with the correct 'doi'" do
      expect(event.as_indexed_json["doi"]).to(eq(["10.0000/subj.id", "10.0000/obj.id"]))
    end

    it "returns a response with the correct 'orcid'" do
      event.subj = { "author": [{ "@id": "https://orcid.org/0000-0000-0000-0000" }] }.to_json

      expect(event.as_indexed_json["orcid"]).to(eq(["0000-0000-0000-0000"]))
    end

    it "returns a response with the correct 'issn'" do
      event.subj = { "periodical": { "issn": "fake-issn" } }.to_json

      expect(event.as_indexed_json["issn"]).to(eq(["fake-issn"]))
    end

    it "returns a response with the correct 'prefix'" do
      expect(event.as_indexed_json["prefix"]).to(eq(["10.0000", "10.0000"]))
    end

    it "returns a response with the correct 'subtype'" do
      event.subj = { "@type": "fake-type-subj" }.to_json
      event.obj = { "@type": "fake-type-obj" }.to_json

      expect(event.as_indexed_json["subtype"]).to(eq(["fake-type-subj", "fake-type-obj"]))
    end

    it "returns a response with the correct 'citation_type'" do
      event.subj = { "@type": "fake-citation-type-subj" }.to_json
      event.obj = { "@type": "fake-citation-type-obj" }.to_json

      expect(event.as_indexed_json["citation_type"]).to(eq("fake-citation-type-obj-fake-citation-type-subj"))
    end

    it "returns a response with the correct 'source_id'" do
      event.source_id = "fake-source-id"

      expect(event.as_indexed_json["source_id"]).to(eq("fake-source-id"))
    end

    it "returns a response with the correct 'source_token'" do
      event.source_token = "fake-source-token"

      expect(event.as_indexed_json["source_token"]).to(eq("fake-source-token"))
    end

    it "returns a response with the correct 'message_action'" do
      event.message_action = "fake-message-action"

      expect(event.as_indexed_json["message_action"]).to(eq("fake-message-action"))
    end

    it "returns a response with the correct 'relation_type_id'" do
      expect(event.as_indexed_json["relation_type_id"]).to(eq("cites"))
    end

    it "returns a response with the correct 'registrant_id'" do
      event.subj = { "registrantId": "fake-registrant-id" }.to_json

      expect(event.as_indexed_json["registrant_id"]).to(eq(["fake-registrant-id"]))
    end

    it "returns a response with the correct 'access_method'" do
      event.relation_type_id = "fake-investigations-access-method"

      expect(event.as_indexed_json["access_method"]).to(eq("method"))
    end

    it "returns a response with the correct 'metric_type'" do
      event.relation_type_id = "fake-investigations-metric-type"

      expect(event.as_indexed_json["metric_type"]).to(eq("fake-investigations-metric"))
    end

    it "returns a response with the correct 'total'" do
      event.total = 100

      expect(event.as_indexed_json["total"]).to(eq(100))
    end

    it "returns a response with the correct 'license'" do
      event.license = "fake-license"

      expect(event.as_indexed_json["license"]).to(eq("fake-license"))
    end

    it "returns a response with the correct 'error_messages'" do
      event.error_messages = "this is an error message"

      expect(event.as_indexed_json["error_messages"]).to(eq("this is an error message"))
    end

    it "returns a response with the correct 'aasm_state'" do
      expect(event.as_indexed_json["aasm_state"]).to(eq("waiting"))
    end

    it "returns a response with the correct 'state_event'" do
      expect(event.as_indexed_json["state_event"]).to(be_nil)
    end

    it "returns a response with the correct 'year_month'" do
      event.occurred_at = "2025-01-01 00:00:00"

      expect(event.as_indexed_json["year_month"]).to(eq("2025-01"))
    end

    it "returns a response with the correct 'indexed_at'" do
      expect(event.as_indexed_json["indexed_at"]).to(eq("2025-01-01 00:00:00"))
    end

    it "returns a response with the correct 'occurred_at'" do
      event.occurred_at = "2025-01-01 00:00:00"

      expect(event.as_indexed_json["occurred_at"]).to(eq("2025-01-01 00:00:00"))
    end

    it "returns a response with the correct 'citation_id'" do
      expect(event.as_indexed_json["citation_id"]).to(eq("10.0000/obj.id-10.0000/subj.id"))
    end

    it "returns a response with the correct 'citation_year'" do
      event.subj = { "datePublished": "2025-01-01 00:00:00" }.to_json

      expect(event.as_indexed_json["citation_year"]).to(eq(2025))
    end

    it "returns a response with the correct 'cache_key'" do
      travel_to(Time.zone.parse("2025-01-01T00:00:00Z")) do
        expected = "events/00000000-0000-0000-0000-000000000000-2025-01-01T00:00:00Z"

        expect(event.as_indexed_json["cache_key"]).to(eq(expected))
      end
    end
  end

  describe ".subj_cache_key" do
    it "when subj_hash has 'dateModified' returns expected result" do
      event.subj_id = "00.0000/zenodo.00000000"
      event.subj = { "dateModified": "2025-01-01 00:00:00" }.to_json

      expect(event.subj_cache_key).to(eq("objects/00.0000/zenodo.00000000-2025-01-01 00:00:00"))
    end

    it "when subj_hash does not have a 'dateModified' returns expected result" do
      travel_to(Time.zone.parse("2025-01-01T00:00:00Z")) do
        event.subj_id = "00.0000/zenodo.00000000"
        event.subj = { "key": "value" }.to_json

        expect(event.subj_cache_key).to(eq("objects/00.0000/zenodo.00000000-2025-01-01T00:00:00Z"))
      end
    end
  end

  describe ".obj_cache_key" do
    it "when obj_hash has 'dateModified' returns expected result" do
      event.obj_id = "00.0000/zenodo.00000000"
      event.obj = { "dateModified": "2025-01-01 00:00:00" }.to_json

      expect(event.obj_cache_key).to(eq("objects/00.0000/zenodo.00000000-2025-01-01 00:00:00"))
    end

    it "when obj_hash does not have a 'dateModified' returns expected result" do
      travel_to(Time.zone.parse("2025-01-01T00:00:00Z")) do
        event.obj_id = "00.0000/zenodo.00000000"
        event.obj = { "key": "value" }.to_json

        expect(event.obj_cache_key).to(eq("objects/00.0000/zenodo.00000000-2025-01-01T00:00:00Z"))
      end
    end
  end

  describe ".doi" do
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
        funders = [
          { "@id": "10.0000/zenodo.0000" },
          { "@id": "10.0001/zenodo.0001" },
        ]

        event.subj_id = nil
        event.obj_id = nil
        event.subj = { "funder": funders }.to_json

        expect(event.doi).to(eq(["10.0000/zenodo.0000", "10.0001/zenodo.0001"]))
      end

      it "when obj_hash has 'funder' adds to doi" do
        funders = [
          { "@id": "10.0000/zenodo.0000" },
          { "@id": "10.0001/zenodo.0001" },
        ]

        event.subj_id = nil
        event.obj_id = nil
        event.obj = { "funder": funders }.to_json

        expect(event.doi).to(eq(["10.0000/zenodo.0000", "10.0001/zenodo.0001"]))
      end

      it "when 'subj_id' is a doi adds to doi" do
        event.subj_id = "10.0000/zenodo.0000"
        event.obj_id = nil

        expect(event.doi).to(eq(["10.0000/zenodo.0000"]))
      end

      it "when 'obj_id' is a doi adds to doi" do
        event.obj_id = "10.0000/zenodo.0000"
        event.subj_id = nil

        expect(event.doi).to(eq(["10.0000/zenodo.0000"]))
      end

      it "when all values do not have valid dois returns empty array" do
        funders = [{ "@id": "http://fake-doi/this-will-not-resolve" }]

        event.subj_id = "http://fake-doi/this-will-not-resolve"
        event.obj_id = "http://fake-doi/this-will-not-resolve"
        event.subj = { "funder": funders }.to_json
        event.obj = { "funder": funders }.to_json

        expect(event.doi).to(be_empty)
      end
    end
  end

  describe ".orcid" do
    it "when subj has 'author' adds to orcid" do
      authors = [
        { "@id": "https://orcid.org/0000-0000-0000-0000" },
        { "@id": "https://orcid.org/0001-0001-0001-0001" },
      ]

      event.subj_id = nil
      event.obj_id = nil
      event.subj = { "author": authors }.to_json

      expect(event.orcid).to(eq(["0000-0000-0000-0000", "0001-0001-0001-0001"]))
    end

    it "when obj has 'author' adds to orcid" do
      authors = [
        { "@id" => "https://orcid.org/0000-0000-0000-0000" },
        { "@id" => "https://orcid.org/0001-0001-0001-0001" },
      ]

      event.subj_id = nil
      event.obj_id = nil
      event.obj = { "author": authors }.to_json

      expect(event.orcid).to(eq(["0000-0000-0000-0000", "0001-0001-0001-0001"]))
    end

    it "when 'subj_id' is an orcid adds to orcid" do
      event.subj_id = "https://orcid.org/0000-0000-0000-0000"
      event.obj_id = nil

      expect(event.orcid).to(eq(["0000-0000-0000-0000"]))
    end

    it "when 'obj_id' is an orcid adds to orcid" do
      event.subj_id = nil
      event.obj_id = "https://orcid.org/0000-0000-0000-0000"

      expect(event.orcid).to(eq(["0000-0000-0000-0000"]))
    end

    it "when all values do not have valid dois returns empty array" do
      authors = [{ "@id": "http://fake-orcid/this-will-not-resolve" }]

      event.subj_id = "http://fake-orcid/this-will-not-resolve"
      event.obj_id = "http://fake-orcid/this-will-not-resolve"
      event.subj = { "author": authors }.to_json
      event.obj = { "author": authors }.to_json

      expect(event.orcid).to(be_empty)
    end
  end

  describe ".issn" do
    it "when subj has 'periodical' containing 'issn' adds to issn" do
      event.subj = { "periodical": { "issn": "fake-issn" } }.to_json

      expect(event.issn).to(eq(["fake-issn"]))
    end

    it "when obj has 'periodical' containing 'issn' adds to issn" do
      event.obj = { "periodical": { "issn": "fake-issn" } }.to_json

      expect(event.issn).to(eq(["fake-issn"]))
    end

    it "when subj does not contain an issn and obj does not contain an issn returns an empty array" do
      expect(event.issn).to(be_empty)
    end
  end

  describe ".prefix" do
    it "when doi has dois returns the prefix of each doi" do
      event.subj_id = "10.0000/0000"
      event.obj_id = "10.0001/0001"

      event.subj = {
        "proxyIdentifiers": ["10.0002/0002"],
        "funder": [{ "@id": "10.0003/0003" }],
      }.to_json

      event.obj = {
        "proxyIdentifiers": ["10.0004/0004"],
        "funder": [{ "@id": "10.0005/0005" }],
      }.to_json

      expect(event.prefix.flatten).to(contain_exactly(
        "10.0000",
        "10.0001",
        "10.0002",
        "10.0003",
        "10.0004",
        "10.0005",
      ))
    end

    it "when doi is an empty array returns an empty array" do
      event.subj_id = nil
      event.obj_id = nil

      expect(event.prefix.flatten).to(be_empty)
    end
  end

  describe ".subtype" do
    it "when subj has a '@type' adds it to the subtype array" do
      event.subj = { "@type": "subj-fake-type" }.to_json

      expect(event.subtype).to(contain_exactly("subj-fake-type"))
    end

    it "when obj has a '@type' adds it to the subtype array" do
      event.obj = { "@type": "obj-fake-type" }.to_json

      expect(event.subtype).to(contain_exactly("obj-fake-type"))
    end

    it "when subj and obj have a '@type' adds it to the subtype array" do
      event.subj = { "@type": "subj-fake-type" }.to_json
      event.obj = { "@type": "obj-fake-type" }.to_json

      expect(event.subtype).to(contain_exactly("subj-fake-type", "obj-fake-type"))
    end

    it "when subj and obj '@type' is missing or nil returns nil" do
      expect(event.subtype).to(be_empty)
    end
  end

  describe ".citation_type" do
    it "when subj_hash returns nil for '@type' returns nil" do
      event.subj = nil
      event.obj = { "@type": "fake-type" }.to_json

      expect(event.citation_type).to(be_nil)
    end

    it "when subj_hash returns 'CreativeWork' for '@type' returns nil" do
      event.subj = { "@typ": "CreativeWork" }.to_json
      event.obj = { "@type": "fake-type" }.to_json

      expect(event.citation_type).to(be_nil)
    end

    it "when obj_hash returns nil for '@type' returns nil" do
      event.obj = nil
      event.subj = { "@type": "fake-type" }.to_json

      expect(event.citation_type).to(be_nil)
    end

    it "when obj_hash returns 'CreativeWork' for '@type' returns nil" do
      event.obj = { "@typ": "CreativeWork" }.to_json
      event.subj = { "@type": "fake-type" }.to_json

      expect(event.citation_type).to(be_nil)
    end

    it "when obj_hash and subj_hash have valid @type values returns the correct ordered value" do
      event.subj = { "@type": "subj-type" }.to_json
      event.obj = { "@type": "obj-type" }.to_json

      # Make sure the sort order is correct
      expect(event.citation_type).to(eq("obj-type-subj-type"))
    end
  end

  describe ".registrant_id" do
    it "when subj_hash has a non-nil 'registrantId' adds to array result" do
      event.subj = { "registrantId": "subj-registrant-id" }.to_json

      expect(event.registrant_id).to(contain_exactly("subj-registrant-id"))
    end

    it "when obj_hash has a non-nil 'registrantId' adds to array result" do
      event.obj = { "registrantId": "obj-registrant-id" }.to_json

      expect(event.registrant_id).to(contain_exactly("obj-registrant-id"))
    end

    it "when subj_hash has a non-nil 'providerId' adds to array result" do
      event.subj = { "providerId": "subj-provider-id" }.to_json

      expect(event.registrant_id).to(contain_exactly("subj-provider-id"))
    end

    it "when obj_hash has a non-nil 'providerId' adds to array result" do
      event.obj = { "providerId": "obj-provider-id" }.to_json

      expect(event.registrant_id).to(contain_exactly("obj-provider-id"))
    end

    it "when obj_hash and subj_hash both do not contain a 'registrantId' and a 'providerId' returns an empty array" do
      expect(event.registrant_id).to(be_empty)
    end
  end

  describe ".access_method" do
    it "when 'relation_type_id' is blank it returns nil" do
      expect(event.access_method).to(be_nil)
    end

    it "when 'relation_type_id' does not contain either 'requests' or 'investigations'" do
      event.relation_type_id = "not-a-valid-relation-type-id"

      expect(event.access_method).to(be_nil)
    end

    it "when 'relation_type_id' contains 'requests' returns the correct result" do
      event.relation_type_id = "a-requests-value"

      expect(event.access_method).to(eq("value"))
    end

    it "when 'relation_type_id' contains 'investigations' returns the correct result" do
      event.relation_type_id = "a-investigations-value"

      expect(event.access_method).to(eq("value"))
    end
  end

  describe ".metric_type" do
    it "when 'relation_type_id' is blank returns nil" do
      expect(event.metric_type).to(be_nil)
    end

    it "when 'relation_type_id' does not contain 'requests' returns nil" do
      event.relation_type_id = "not-a-valid-relation-type-id"

      expect(event.metric_type).to(be_nil)
    end

    it "when 'relation_type_id' contains 'requests' returns the correct result" do
      event.relation_type_id = "one-two-three-requests"

      expect(event.metric_type).to(eq("one-two-three"))
    end

    it "when 'relation_type_id' contains 'investigations' returns the correct result" do
      event.relation_type_id = "one-two-three-investigations"

      expect(event.metric_type).to(eq("one-two-three"))
    end
  end

  describe ".year_month" do
    it "when 'occurred_at' is blank returns nil" do
      expect(event.year_month).to(be_nil)
    end

    it "when 'occurred_at' is present returns the year and month" do
      event.occurred_at = Time.zone.local(2025, 1, 1, 0, 0, 0)

      expect(event.year_month).to(eq("2025-01"))
    end
  end

  describe ".citation_id" do
    it "returns the subj_id and obj_id sorted and joined by a hyphen" do
      event.subj_id = "fake-subj-id"
      event.obj_id = "fake-obj-id"

      expect(event.citation_id).to(eq("fake-obj-id-fake-subj-id"))
    end
  end

  describe ".citation_year" do
    it "when 'relation_type_id' is not an included relation type or relations relation type
        returns an empty string" do
      event.relation_type_id = "fake-type"

      expect(event.citation_year).to(eq(0))
    end

    describe "when obj_hash is empty" do
      before do
        event.relation_type_id = "cites"
      end

      it "when subj_hash has 'datePublished' returns the correct year" do
        event.subj = { "datePublished": "2025-01-01 00:00:00" }.to_json

        expect(event.citation_year).to(eq(2025))
      end

      it "when subj_hash has 'date_published' returns the correct year" do
        event.subj = { "date_published": "2025-01-01 00:00:00" }.to_json

        expect(event.citation_year).to(eq(2025))
      end

      it "when subj_hash does not have a date published value returns doi publication year" do
        allow(event).to(receive(:date_published).with(event.subj_id).and_return("2025"))
        allow(event).to(receive(:date_published).with(event.obj_id).and_return(nil))

        expect(event.citation_year).to(eq(2025))
      end

      it "when subj_hash does not have a date published value and the doi does not have a publication year
          return year_month year" do
        event.occurred_at = Time.zone.local(2025, 1, 1, 0, 0, 0)

        expect(event.citation_year).to(eq(2025))
      end

      it "when there are no valid dates available return 0" do
        expect(event.citation_year).to(eq(0))
      end
    end

    describe "when subj_hash is empty" do
      before do
        event.relation_type_id = "cites"
      end

      it "when obj_hash has 'datePublished' returns the correct year" do
        event.obj = { "datePublished": "2025-01-01 00:00:00" }.to_json

        expect(event.citation_year).to(eq(2025))
      end

      it "when obj_hash has 'date_published' returns the correct year" do
        event.obj = { "date_published": "2025-01-01 00:00:00" }.to_json

        expect(event.citation_year).to(eq(2025))
      end

      it "when obj_hash does not have a date published value returns doi publication year" do
        allow(event).to(receive(:date_published).with(event.obj_id).and_return("2025"))
        allow(event).to(receive(:date_published).with(event.subj_id).and_return(nil))

        expect(event.citation_year).to(eq(2025))
      end

      it "when obj_hash does not have a date published value and the doi does not have a publication year
          return year_month year" do
        event.occurred_at = Time.zone.local(2025, 1, 1, 0, 0, 0)

        expect(event.citation_year).to(eq(2025))
      end

      it "when there are no valid dates available return 0" do
        expect(event.citation_year).to(eq(0))
      end
    end

    describe "when subj and obj are non-nil" do
      before do
        event.relation_type_id = "cites"
      end

      it "returns the max year when subj year is greater than obj year" do
        # Testing values are subj.year_month and obj.datePublished

        event.occurred_at = "2025-01-01 00:00:00"
        event.obj = { "datePublished": "2024-01-01 00:00:00" }.to_json

        expect(event.citation_year).to(eq(2025))
      end

      it "returns the max year when obj year is greater than subj year" do
        # Testing values are subj.datePublished and obj.date_published

        event.subj = { "datePublished": "2024-01-01 00:00:00" }.to_json
        event.obj = { "date_published": "2025-01-01 00:00:00" }.to_json

        expect(event.citation_year).to(eq(2025))
      end

      it "returns the max year when subj year is equal to obj year" do
        # Testing values are subj.datePublished and obj.datePublished

        event.subj = { "datePublished": "2025-01-01 00:00:00" }.to_json
        event.obj = { "datePublished": "2025-01-02 00:00:00" }.to_json

        expect(event.citation_year).to(eq(2025))
      end
    end
  end

  describe ".cache_key" do
    it "when updated_at is present returns the expect value" do
      event.updated_at = Time.zone.local(2025, 1, 1, 0, 0, 0)

      expected = "events/00000000-0000-0000-0000-000000000000-2025-01-01T00:00:00Z"

      expect(event.cache_key).to(eq(expected))
    end

    it "when updated_at is blank returns the expected value" do
      travel_to(Time.zone.parse("2025-01-01T00:00:00Z")) do
        expected = "events/00000000-0000-0000-0000-000000000000-2025-01-01T00:00:00Z"

        expect(event.cache_key).to(eq(expected))
      end
    end
  end

  describe ".date_published" do
    it "returns the expected result" do
      allow(Doi).to(receive(:publication_date).and_return(2025))

      expect(event.date_published("fake-doi")).to(eq(2025))
    end
  end
end

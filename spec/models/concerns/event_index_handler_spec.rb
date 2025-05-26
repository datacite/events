# frozen_string_literal: true

require "rails_helper"

RSpec.describe(EventIndexHandler, type: :concern) do
  include ActiveSupport::Testing::TimeHelpers

  let(:event) { build(:event) }

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

  # describe ".citation_year" do
  #   it "when 'relation_type_id' is not an included relation type or relations relation type returns an empty string" do
  #     event.relation_type_id = "fake-type"

  #     expect(event.citation_year).to(eq(""))
  #   end

  #   (RelationTypes::REFERENCE_RELATION_TYPES | RelationTypes::CITATION_RELATION_TYPES).each do |relation_type|
  #     describe "when obj_hash is empty" do
  #       before do
  #         event.relation_type_id = relation_type
  #       end

  #       it "when subj_hash has 'datePublished' returns the correct year" do
  #         event.subj = { "datePublished": "2025-01-01 00:00:00" }.to_json
  #         event.obj = nil

  #         expect(event.citation_year).to(eq(2025))
  #       end

  #       it "when subj_hash has 'date_published' returns the correct year" do
  #         event.subj = { "date_published": "2025-01-01 00:00:00" }.to_json

  #         expect(event.citation_year).to(eq(2025))
  #       end

  #       it "when subj_hash does not have a date published value returns doi publication year" do
  #         allow(event).to(receive(:date_published).with(event.subj_id).and_return("2025"))
  #         allow(event).to(receive(:date_published).with(event.obj_id).and_return(nil))

  #         expect(event.citation_year).to(eq(2025))
  #       end

  #       it "when subj_hash does not have a date published value and the doi does not have a publication year return year_month" do
  #         event.occurred_at = Time.zone.local(2025, 1, 1, 0, 0, 0)

  #         expect(event.citation_year).to(eq("2025-01"))
  #       end
  #     end
  #   end
  # end

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
end

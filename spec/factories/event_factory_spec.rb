# frozen_string_literal: true

require "active_support/testing/time_helpers"

RSpec.describe(EventFactory) do
  include ActiveSupport::Testing::TimeHelpers

  describe "#create_instance_from_sqs" do
    describe "uuid" do
      it "is set via message body when present" do
        message = { "uuid" => "00000001-0001-0001-0001-000100010001" }
        event = described_class.create_instance_from_sqs(message)

        expect(event.uuid).to(eq("00000001-0001-0001-0001-000100010001"))
      end

      it "is set via SecureRandom when missing from message body" do
        allow(SecureRandom).to(receive(:uuid).and_return("00000001-0001-0001-0001-000100010001"))

        message = { "uuid": nil }
        event = described_class.create_instance_from_sqs(message)

        expect(event.uuid).to(eq("00000001-0001-0001-0001-000100010001"))
      end
    end

    describe "subjId" do
      it "is set via message body when present" do
        message = { "subjId" => "https://doi.org/10.5281/zenodo.subjId" }
        event = described_class.create_instance_from_sqs(message)

        expect(event.subj_id).to(eq("https://doi.org/10.5281/zenodo.subjId"))
      end

      it "is set using DoiUtilities when missing from message body" do
        allow(DoiUtilities).to(receive(:normalize_doi).and_return("https://doi.org/10.5281/zenodo.subjId"))

        message = { "subjId" => nil }
        event = described_class.create_instance_from_sqs(message)

        expect(event.subj_id).to(eq("https://doi.org/10.5281/zenodo.subjId"))
      end
    end

    describe "objId" do
      it "is set via message body when present" do
        message = { "objId" => "https://doi.org/10.5281/zenodo.objId" }
        event = described_class.create_instance_from_sqs(message)

        expect(event.obj_id).to(eq("https://doi.org/10.5281/zenodo.objId"))
      end

      it "is set using DoiUtilities when missing from message body" do
        allow(DoiUtilities).to(receive(:normalize_doi).and_return("https://doi.org/10.5281/zenodo.objId"))

        message = { "objId" => nil }
        event = described_class.create_instance_from_sqs(message)

        expect(event.obj_id).to(eq("https://doi.org/10.5281/zenodo.objId"))
      end
    end

    describe "sourceId" do
      it "is set via message body when present" do
        message = { "sourceId" => "orcid-affiliation" }
        event = described_class.create_instance_from_sqs(message)

        expect(event.source_id).to(eq("orcid-affiliation"))
      end

      it "is nil when not present in message body" do
        message = { "sourceId" => nil }
        event = described_class.create_instance_from_sqs(message)

        expect(event.source_id).to(be_nil)
      end
    end

    describe "aasm_state" do
      it "is always set to 'waiting'" do
        message = {}
        event = described_class.create_instance_from_sqs(message)

        expect(event.aasm_state).to(eq("waiting"))
      end
    end

    describe "source_token" do
      it "is set via the message body when present" do
        message = { "sourceToken" => "00010001-0001-0001-000100010001" }
        event = described_class.create_instance_from_sqs(message)

        expect(event.source_token).to(eq("00010001-0001-0001-000100010001"))
      end

      it "is nil when not present in message body" do
        message = {}
        event = described_class.create_instance_from_sqs(message)

        expect(event.source_token).to(be_nil)
      end
    end

    describe "total" do
      it "is set via the message body when present" do
        message = { "total" => 1000 }
        event = described_class.create_instance_from_sqs(message)

        expect(event.total).to(eq(1000))
      end

      it "is 1 when not present in message body" do
        message = {}
        event = described_class.create_instance_from_sqs(message)

        expect(event.total).to(eq(1))
      end
    end

    describe "occurred_at" do
      it "is set via the message body when present" do
        message = { "occurredAt" => "2025-01-01 00:00:00" }
        event = described_class.create_instance_from_sqs(message)

        expect(event.occurred_at).to(eq("2025-01-01 00:00:00"))
      end

      it "is set using Time.now.utc when not present in message body" do
        travel_to(Time.utc(2025, 1, 1, 0, 0, 0)) do
          message = {}
          event = described_class.create_instance_from_sqs(message)

          expect(event.occurred_at).to(eq("2025-01-01 00:00:00"))
        end
      end
    end

    describe "message_action" do
      it "is set from message body when present" do
        message = { "messageAction" => "fake-message-action" }
        event = described_class.create_instance_from_sqs(message)

        expect(event.message_action).to(eq("fake-message-action"))
      end

      it "is set to 'create' when not present in message body" do
        message = {}
        event = described_class.create_instance_from_sqs(message)

        expect(event.message_action).to(eq("create"))
      end
    end

    describe "relation_type_id" do
      it "is set via the message body when present" do
        message = { "relationTypeId" => "fake-relation-type-id" }
        event = described_class.create_instance_from_sqs(message)

        expect(event.relation_type_id).to(eq("fake-relation-type-id"))
      end

      it "is 'references' when not present in message body" do
        message = {}
        event = described_class.create_instance_from_sqs(message)

        expect(event.relation_type_id).to(eq("references"))
      end
    end

    describe "subj" do
      it "is set via the message body when present" do
        subj = { "field": "value" }

        message = { "subj" => subj }
        event = described_class.create_instance_from_sqs(message)

        expect(event.subj).to(eq(subj.to_json))
      end

      it "is nil when not present in message body" do
        message = {}
        event = described_class.create_instance_from_sqs(message)

        expect(event.subj).to(be_nil)
      end
    end

    describe "obj" do
      it "is set via the message body when present" do
        obj = { "field": "value" }

        message = { "obj" => obj }
        event = described_class.create_instance_from_sqs(message)

        expect(event.obj).to(eq(obj.to_json))
      end

      it "is nil when not present in message body" do
        message = {}
        event = described_class.create_instance_from_sqs(message)

        expect(event.obj).to(be_nil)
      end
    end

    describe "license" do
      it "is set via the message body when present" do
        message = { "license" => "https://fakelicense.org/publicdomain/zero/1.0/" }
        event = described_class.create_instance_from_sqs(message)

        expect(event.license).to(eq("https://fakelicense.org/publicdomain/zero/1.0/"))
      end

      it "is 'https://creativecommons.org/publicdomain/zero/1.0/' when not present in message body" do
        message = {}
        event = described_class.create_instance_from_sqs(message)

        expect(event.license).to(eq("https://creativecommons.org/publicdomain/zero/1.0/"))
      end
    end

    describe "source_id" do
      it "is set via the message body when present" do
        message = { "sourceId" => "orcid-affiliation" }
        event = described_class.create_instance_from_sqs(message)

        expect(event.source_id).to(eq("orcid-affiliation"))
      end

      it "is nil when not present in message body" do
        message = {}
        event = described_class.create_instance_from_sqs(message)

        expect(event.source_id).to(be_nil)
      end
    end

    describe "indexed_at" do
      it "is set to '1970-01-01 00:00:00'" do
        message = {}
        event = described_class.create_instance_from_sqs(message)

        expect(event.indexed_at).to(eq("1970-01-01 00:00:00"))
      end
    end
  end

  describe "#update_instance_from_sqs" do
    describe "uuid" do
      it "is set via message body when present" do
        event = Event.new(uuid: "11111111-1111-1111-1111-111111111111")
        message = { "uuid" => "00000001-0001-0001-0001-000100010001" }
        described_class.update_instance_from_sqs(event, message)

        expect(event.uuid).to(eq("00000001-0001-0001-0001-000100010001"))
      end

      it "does not update the uuid value when not present in message body" do
        event = Event.new(uuid: "00000001-0001-0001-0001-000100010001")
        message = {}
        described_class.update_instance_from_sqs(event, message)

        expect(event.uuid).to(eq("00000001-0001-0001-0001-000100010001"))
      end
    end

    describe "source_id" do
      it "is set via message body when present" do
        event = Event.new(source_id: "orcid-affiliation")
        message = { "sourceId" => "datacite-crossref" }
        described_class.update_instance_from_sqs(event, message)

        expect(event.source_id).to(eq("datacite-crossref"))
      end

      it "does not update the source_id value when not present in message body" do
        event = Event.new(source_id: "orcid-affiliation")
        message = {}
        described_class.update_instance_from_sqs(event, message)

        expect(event.source_id).to(eq("orcid-affiliation"))
      end
    end

    describe "source_token" do
      it "is set via message body when present" do
        event = Event.new(source_token: "00010001-0001-0001-0001-000100010001")
        message = { "sourceToken" => "00020002-0002-0002-0002-000200020002" }
        described_class.update_instance_from_sqs(event, message)

        expect(event.source_token).to(eq("00020002-0002-0002-0002-000200020002"))
      end

      it "does not update the source_token value when not present in message body" do
        event = Event.new(source_token: "00010001-0001-0001-0001-000100010001")
        message = {}
        described_class.update_instance_from_sqs(event, message)

        expect(event.source_token).to(eq("00010001-0001-0001-0001-000100010001"))
      end
    end

    describe "total" do
      it "is set via message body when present" do
        event = Event.new(total: 100)
        message = { "total" => 1000 }
        described_class.update_instance_from_sqs(event, message)

        expect(event.total).to(eq(1000))
      end

      it "does not update the total value when not present in message body" do
        event = Event.new(total: 100)
        message = {}
        described_class.update_instance_from_sqs(event, message)

        expect(event.total).to(eq(100))
      end
    end

    describe "occurred_at" do
      it "is set via message body when present" do
        event = Event.new(occurred_at: "2025-01-01 00:00:00")
        message = { "occurredAt" => "2025-01-02 00:00:00" }
        described_class.update_instance_from_sqs(event, message)

        expect(event.occurred_at.strftime("%Y-%m-%d %H:%M:%S")).to(eq("2025-01-02 00:00:00"))
      end

      it "does not update the occurred_at value when not present in message body" do
        event = Event.new(occurred_at: "2025-01-01 00:00:00")
        message = {}
        described_class.update_instance_from_sqs(event, message)

        expect(event.occurred_at.strftime("%Y-%m-%d %H:%M:%S")).to(eq("2025-01-01 00:00:00"))
      end
    end

    describe "relation_type_id" do
      it "is set via message body when present" do
        event = Event.new(relation_type_id: "orcid-affiliation")
        message = { "relationTypeId" => "datacite-crossref" }
        described_class.update_instance_from_sqs(event, message)

        expect(event.relation_type_id).to(eq("datacite-crossref"))
      end

      it "does not update the relation_type_id value when not present in message body" do
        event = Event.new(relation_type_id: "orcid-affiliation")
        message = {}
        described_class.update_instance_from_sqs(event, message)

        expect(event.relation_type_id).to(eq("orcid-affiliation"))
      end
    end

    describe "license" do
      it "is set via message body when present" do
        event = Event.new(license: "https://creativecommons.org/publicdomain/zero/1.0/")
        message = { "license" => "https://fakelicense.org/publicdomain/zero/1.0/" }
        described_class.update_instance_from_sqs(event, message)

        expect(event.license).to(eq("https://fakelicense.org/publicdomain/zero/1.0/"))
      end

      it "does not update the license value when not present in message body" do
        event = Event.new(license: "https://creativecommons.org/publicdomain/zero/1.0/")
        message = {}
        described_class.update_instance_from_sqs(event, message)

        expect(event.license).to(eq("https://creativecommons.org/publicdomain/zero/1.0/"))
      end
    end

    describe "subj" do
      it "is set via the message body when present" do
        subj = { "field" => "value" }
        event = Event.new(subj: subj.to_json)
        subj["field"] = "new value"
        message = { "subj" => subj }
        described_class.update_instance_from_sqs(event, message)

        expect(event.subj).to(eq(subj.to_json))
      end

      it "is nil when not present in message body" do
        subj = { "field" => "value" }
        event = Event.new(subj: subj.to_json)
        message = {}
        described_class.update_instance_from_sqs(event, message)

        expect(event.subj).to(eq(subj.to_json))
      end
    end

    describe "obj" do
      it "is set via the message body when present" do
        obj = { "field" => "value" }
        event = Event.new(obj: obj.to_json)
        obj["field"] = "new value"
        message = { "obj" => obj }
        described_class.update_instance_from_sqs(event, message)

        expect(event.obj).to(eq(obj.to_json))
      end

      it "is not set when not present in message body" do
        obj = { "field" => "value" }
        event = Event.new(obj: obj.to_json)
        message = {}
        described_class.update_instance_from_sqs(event, message)

        expect(event.obj).to(eq(obj.to_json))
      end
    end

    describe "subj_id" do
      it "is not set when not present in message" do
        event = Event.new(subj_id: "10.5281/zenodo.subjId")
        message = {}
        described_class.update_instance_from_sqs(event, message)

        expect(event.subj_id).to(eq("10.5281/zenodo.subjId"))
      end

      it "when available in the message body is set via DoiUtilities.normalize_doi when it returns truthy" do
        allow(DoiUtilities).to(receive(:normalize_doi).and_return("normalized-doi"))

        event = Event.new(subj_id: "10.5281/zenodo.subjId")
        message = { "subjId" => "10.5281/zenodo.newSubjId" }
        described_class.update_instance_from_sqs(event, message)

        expect(event.subj_id).to(eq("normalized-doi"))
      end

      it "is set via message body when DoiUtilities.normalize_doi returns falsey" do
        allow(DoiUtilities).to(receive(:normalize_doi).and_return(nil))

        event = Event.new(subj_id: "10.5281/zenodo.subjId")
        message = { "subjId" => "10.5281/zenodo.newSubjId" }
        described_class.update_instance_from_sqs(event, message)

        expect(event.subj_id).to(eq("10.5281/zenodo.newSubjId"))
      end
    end

    describe "obj_id" do
      it "is not set when not present in message" do
        event = Event.new(obj_id: "10.5281/zenodo.objId")
        message = {}
        described_class.update_instance_from_sqs(event, message)

        expect(event.obj_id).to(eq("10.5281/zenodo.objId"))
      end

      it "when available in the message body is set via DoiUtilities.normalize_doi when it returns truthy" do
        allow(DoiUtilities).to(receive(:normalize_doi).and_return("normalized-doi"))

        event = Event.new(obj_id: "10.5281/zenodo.objId")
        message = { "objId" => "10.5281/zenodo.newObjId" }
        described_class.update_instance_from_sqs(event, message)

        expect(event.obj_id).to(eq("normalized-doi"))
      end

      it "is set via message body when DoiUtilities.normalize_doi returns falsey" do
        allow(DoiUtilities).to(receive(:normalize_doi).and_return(nil))

        event = Event.new(obj_id: "10.5281/zenodo.objId")
        message = { "objId" => "10.5281/zenodo.newObjId" }
        described_class.update_instance_from_sqs(event, message)

        expect(event.obj_id).to(eq("10.5281/zenodo.newObjId"))
      end
    end
  end
end

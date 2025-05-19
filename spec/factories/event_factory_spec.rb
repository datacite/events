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
        message = { "sourceId" => "fake-source-id" }
        event = described_class.create_instance_from_sqs(message)
        puts(message.inspect)

        expect(event.source_id).to(eq("fake-source-id"))
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
        subj = {
          "@id" => "https://doi.org/10.5281/zenodo.subjId",
          "@type" => "Organization",
          "name" => "DataCite",
          "location" => {
            "type" => "postalAddress",
            "addressCountry" => "France",
          },
        }

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
        obj = {
          "@id" => "https://doi.org/10.5281/zenodo.objId",
          "@type" => "Organization",
          "name" => "DataCite",
          "location" => {
            "type" => "postalAddress",
            "addressCountry" => "France",
          },
        }

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
end

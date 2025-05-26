# frozen_string_literal: true

require "rails_helper"

RSpec.describe(EventFromSqsUpdater) do
  include ActiveSupport::Testing::TimeHelpers

  describe "#update_instance_from_sqs" do
    describe "uuid" do
      it "is set via message body when present" do
        event = build(:event, uuid: "11111111-1111-1111-1111-111111111111")
        message = { "uuid" => "00000001-0001-0001-0001-000100010001" }
        event.update_instance_from_sqs(message)

        expect(event.uuid).to(eq("00000001-0001-0001-0001-000100010001"))
      end

      it "does not update when not present in message body" do
        event = build(:event, uuid: "00000001-0001-0001-0001-000100010001")
        message = {}
        event.update_instance_from_sqs(message)

        expect(event.uuid).to(eq("00000001-0001-0001-0001-000100010001"))
      end
    end

    describe "source_id" do
      it "is set via message body when present" do
        event = build(:event, source_id: "orcid-affiliation")
        message = { "sourceId" => "datacite-crossref" }
        event.update_instance_from_sqs(message)

        expect(event.source_id).to(eq("datacite-crossref"))
      end

      it "does not update when not present in message body" do
        event = build(:event, source_id: "orcid-affiliation")
        message = {}
        event.update_instance_from_sqs(message)

        expect(event.source_id).to(eq("orcid-affiliation"))
      end
    end

    describe "source_token" do
      it "is set via message body when present" do
        event = build(:event, source_token: "00010001-0001-0001-0001-000100010001")
        message = { "sourceToken" => "00020002-0002-0002-0002-000200020002" }
        event.update_instance_from_sqs(message)

        expect(event.source_token).to(eq("00020002-0002-0002-0002-000200020002"))
      end

      it "does not update when not present in message body" do
        event = build(:event, source_token: "00010001-0001-0001-0001-000100010001")
        message = {}
        event.update_instance_from_sqs(message)

        expect(event.source_token).to(eq("00010001-0001-0001-0001-000100010001"))
      end
    end

    describe "total" do
      it "is set via message body when present" do
        event = build(:event, total: 100)
        message = { "total" => 1000 }
        event.update_instance_from_sqs(message)

        expect(event.total).to(eq(1000))
      end

      it "does not update when not present in message body" do
        event = build(:event, total: 100)
        message = {}
        event.update_instance_from_sqs(message)

        expect(event.total).to(eq(100))
      end
    end

    describe "occurred_at" do
      it "is set via message body when present" do
        event = build(:event, occurred_at: "2025-01-01 00:00:00")
        message = { "occurredAt" => "2025-01-02 00:00:00" }
        event.update_instance_from_sqs(message)

        expect(event.occurred_at.strftime("%Y-%m-%d %H:%M:%S")).to(eq("2025-01-02 00:00:00"))
      end

      it "does not update when not present in message body" do
        event = build(:event, occurred_at: "2025-01-01 00:00:00")
        message = {}
        event.update_instance_from_sqs(message)

        expect(event.occurred_at.strftime("%Y-%m-%d %H:%M:%S")).to(eq("2025-01-01 00:00:00"))
      end
    end

    describe "relation_type_id" do
      it "is set via message body when present" do
        event = build(:event, relation_type_id: "orcid-affiliation")
        message = { "relationTypeId" => "datacite-crossref" }
        event.update_instance_from_sqs(message)

        expect(event.relation_type_id).to(eq("datacite-crossref"))
      end

      it "does not update when not present in message body" do
        event = build(:event, relation_type_id: "orcid-affiliation")
        message = {}
        event.update_instance_from_sqs(message)

        expect(event.relation_type_id).to(eq("orcid-affiliation"))
      end
    end

    describe "license" do
      it "is set via message body when present" do
        event = build(:event, license: "https://creativecommons.org/publicdomain/zero/1.0/")
        message = { "license" => "https://fakelicense.org/publicdomain/zero/1.0/" }
        event.update_instance_from_sqs(message)

        expect(event.license).to(eq("https://fakelicense.org/publicdomain/zero/1.0/"))
      end

      it "does not update when not present in message body" do
        event = build(:event, license: "https://creativecommons.org/publicdomain/zero/1.0/")
        message = {}
        event.update_instance_from_sqs(message)

        expect(event.license).to(eq("https://creativecommons.org/publicdomain/zero/1.0/"))
      end
    end

    describe "subj" do
      it "is set via the message body when present" do
        subj = { "field" => "value" }
        event = build(:event, subj: subj.to_json)
        subj["field"] = "new value"
        message = { "subj" => subj }
        event.update_instance_from_sqs(message)

        expect(event.subj).to(eq(subj.to_json))
      end

      it "is nil when not present in message body" do
        subj = { "field" => "value" }
        event = build(:event, subj: subj.to_json)
        message = {}
        event.update_instance_from_sqs(message)

        expect(event.subj).to(eq(subj.to_json))
      end
    end

    describe "obj" do
      it "is set via the message body when present" do
        obj = { "field" => "value" }
        event = build(:event, obj: obj.to_json)
        obj["field"] = "new value"
        message = { "obj" => obj }
        event.update_instance_from_sqs(message)

        expect(event.obj).to(eq(obj.to_json))
      end

      it "is not set when not present in message body" do
        obj = { "field" => "value" }
        event = build(:event, obj: obj.to_json)
        message = {}
        event.update_instance_from_sqs(message)

        expect(event.obj).to(eq(obj.to_json))
      end
    end

    describe "subj_id" do
      it "is not set when not present in message" do
        event = build(:event, subj_id: "10.5281/zenodo.subjId")
        message = {}
        event.update_instance_from_sqs(message)

        expect(event.subj_id).to(eq("10.5281/zenodo.subjId"))
      end

      it "when available in the message body is set via DoiUtilities.normalize_doi when it returns truthy" do
        allow(DoiUtilities).to(receive(:normalize_doi).and_return("normalized-doi"))

        event = build(:event, subj_id: "10.5281/zenodo.subjId")
        message = { "subjId" => "10.5281/zenodo.newSubjId" }
        event.update_instance_from_sqs(message)

        expect(event.subj_id).to(eq("normalized-doi"))
      end

      it "is set via message body when DoiUtilities.normalize_doi returns falsey" do
        allow(DoiUtilities).to(receive(:normalize_doi).and_return(nil))

        event = build(:event, subj_id: "10.5281/zenodo.subjId")
        message = { "subjId" => "10.5281/zenodo.newSubjId" }
        event.update_instance_from_sqs(message)

        expect(event.subj_id).to(eq("10.5281/zenodo.newSubjId"))
      end
    end

    describe "obj_id" do
      it "is not set when not present in message" do
        event = build(:event, obj_id: "10.5281/zenodo.objId")
        message = {}
        event.update_instance_from_sqs(message)

        expect(event.obj_id).to(eq("10.5281/zenodo.objId"))
      end

      it "when available in the message body is set via DoiUtilities.normalize_doi when it returns truthy" do
        allow(DoiUtilities).to(receive(:normalize_doi).and_return("normalized-doi"))

        event = build(:event, obj_id: "10.5281/zenodo.objId")
        message = { "objId" => "10.5281/zenodo.newObjId" }
        event.update_instance_from_sqs(message)

        expect(event.obj_id).to(eq("normalized-doi"))
      end

      it "is set via message body when DoiUtilities.normalize_doi returns falsey" do
        allow(DoiUtilities).to(receive(:normalize_doi).and_return(nil))

        event = build(:event, obj_id: "10.5281/zenodo.objId")
        message = { "objId" => "10.5281/zenodo.newObjId" }
        event.update_instance_from_sqs(message)

        expect(event.obj_id).to(eq("10.5281/zenodo.newObjId"))
      end
    end
  end
end

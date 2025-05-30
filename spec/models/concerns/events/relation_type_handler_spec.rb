# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Events::RelationTypeHandler, type: :concern) do
  let(:doi_subj) { "00.0000/zenodo.00000000" }
  let(:doi_obj) { "00.0000/zenodo.00000001" }

  describe "returns early" do
    let(:event) { build(:event) }

    it "when subj_id is blank" do
      event.obj_id = doi_subj
      expect { event.set_source_and_target_doi! }.not_to(change { [event.source_doi, event.target_doi] })
    end

    it "when obj_id is blank" do
      event.subj_id = doi_subj
      expect { event.set_source_and_target_doi! }.not_to(change { [event.source_doi, event.target_doi] })
    end

    it "when subj_id and obj_id are blank" do
      expect { event.set_source_and_target_doi! }.not_to(change { [event.source_doi, event.target_doi] })
    end
  end

  RelationTypes::REFERENCE_RELATION_TYPES.each do |relation_type|
    describe "when relation_type_id is a reference relation type" do
      let(:event) do
        build(
          :event,
          subj_id: doi_subj,
          obj_id: doi_obj,
          relation_type_id: relation_type,
        )
      end

      before do
        allow(DoiUtilities).to(receive(:uppercase_doi_from_url).with(doi_subj).and_return(doi_subj.upcase))
        allow(DoiUtilities).to(receive(:uppercase_doi_from_url).with(doi_obj).and_return(doi_obj.upcase))

        event.set_source_and_target_doi!
      end

      it "sets the correct source_doi" do
        expect(event.source_doi).to(eq(doi_subj.upcase))
      end

      it "sets the correct target_doi" do
        expect(event.target_doi).to(eq(doi_obj.upcase))
      end

      it "sets the source_relation_type_id to references" do
        expect(event.source_relation_type_id).to(eq("references"))
      end

      it "sets the target_relation_type_id to references" do
        expect(event.target_relation_type_id).to(eq("citations"))
      end
    end
  end

  RelationTypes::CITATION_RELATION_TYPES.each do |relation_type|
    describe "when relation_type_id is a citation relation type" do
      let(:event) do
        build(
          :event,
          subj_id: doi_subj,
          obj_id: doi_obj,
          relation_type_id: relation_type,
        )
      end

      before do
        allow(DoiUtilities).to(receive(:uppercase_doi_from_url).with(doi_subj).and_return(doi_subj.upcase))
        allow(DoiUtilities).to(receive(:uppercase_doi_from_url).with(doi_obj).and_return(doi_obj.upcase))

        event.set_source_and_target_doi!
      end

      it "sets the correct source_doi" do
        expect(event.source_doi).to(eq(doi_obj.upcase))
      end

      it "sets the correct target_doi" do
        expect(event.target_doi).to(eq(doi_subj.upcase))
      end

      it "sets the source_relation_type_id to references" do
        expect(event.source_relation_type_id).to(eq("references"))
      end

      it "sets the target_relation_type_id to references" do
        expect(event.target_relation_type_id).to(eq("citations"))
      end
    end
  end

  describe "when relation_type_id is unique-dataset-investigations-regular" do
    let(:event) do
      build(
        :event,
        subj_id: doi_subj,
        obj_id: doi_obj,
        relation_type_id: "unique-dataset-investigations-regular",
      )
    end

    before do
      allow(DoiUtilities).to(receive(:uppercase_doi_from_url).with(doi_obj).and_return(doi_obj.upcase))

      event.set_source_and_target_doi!
    end

    it "sets the correct target_doi" do
      expect(event.target_doi).to(eq(doi_obj.upcase))
    end

    it "sets the target_relation_type_id to views" do
      expect(event.target_relation_type_id).to(eq("views"))
    end
  end

  describe "when relation_type_id is unique-dataset-requests-regular" do
    let(:event) do
      build(
        :event,
        subj_id: doi_subj,
        obj_id: doi_obj,
        relation_type_id: "unique-dataset-requests-regular",
      )
    end

    before do
      allow(DoiUtilities).to(receive(:uppercase_doi_from_url).with(doi_obj).and_return(doi_obj.upcase))

      event.set_source_and_target_doi!
    end

    it "sets the correct target_doi" do
      expect(event.target_doi).to(eq(doi_obj.upcase))
    end

    it "sets the target_relation_type_id to views" do
      expect(event.target_relation_type_id).to(eq("downloads"))
    end
  end

  describe "when relation_type_id is has-version" do
    let(:event) do
      build(
        :event,
        subj_id: doi_subj,
        obj_id: doi_obj,
        relation_type_id: "has-version",
      )
    end

    before do
      allow(DoiUtilities).to(receive(:uppercase_doi_from_url).with(doi_subj).and_return(doi_subj.upcase))
      allow(DoiUtilities).to(receive(:uppercase_doi_from_url).with(doi_obj).and_return(doi_obj.upcase))

      event.set_source_and_target_doi!
    end

    it "sets the correct source_doi" do
      expect(event.source_doi).to(eq(doi_subj.upcase))
    end

    it "sets the correct target_doi" do
      expect(event.target_doi).to(eq(doi_obj.upcase))
    end

    it "sets the source_relation_type_id to versions" do
      expect(event.source_relation_type_id).to(eq("versions"))
    end

    it "sets the target_relation_type_id to version_of" do
      expect(event.target_relation_type_id).to(eq("version_of"))
    end
  end

  describe "when relation_type_id is is-version-of" do
    let(:event) do
      build(
        :event,
        subj_id: doi_subj,
        obj_id: doi_obj,
        relation_type_id: "is-version-of",
      )
    end

    before do
      allow(DoiUtilities).to(receive(:uppercase_doi_from_url).with(doi_subj).and_return(doi_subj.upcase))
      allow(DoiUtilities).to(receive(:uppercase_doi_from_url).with(doi_obj).and_return(doi_obj.upcase))

      event.set_source_and_target_doi!
    end

    it "sets the correct source_doi" do
      expect(event.source_doi).to(eq(doi_obj.upcase))
    end

    it "sets the correct target_doi" do
      expect(event.target_doi).to(eq(doi_subj.upcase))
    end

    it "sets the source_relation_type_id to versions" do
      expect(event.source_relation_type_id).to(eq("versions"))
    end

    it "sets the target_relation_type_id to version_of" do
      expect(event.target_relation_type_id).to(eq("version_of"))
    end
  end

  describe "when relation_type_id is has-part" do
    let(:event) do
      build(
        :event,
        subj_id: doi_subj,
        obj_id: doi_obj,
        relation_type_id: "has-part",
      )
    end

    before do
      allow(DoiUtilities).to(receive(:uppercase_doi_from_url).with(doi_subj).and_return(doi_subj.upcase))
      allow(DoiUtilities).to(receive(:uppercase_doi_from_url).with(doi_obj).and_return(doi_obj.upcase))

      event.set_source_and_target_doi!
    end

    it "sets the correct source_doi" do
      expect(event.source_doi).to(eq(doi_subj.upcase))
    end

    it "sets the correct target_doi" do
      expect(event.target_doi).to(eq(doi_obj.upcase))
    end

    it "sets the source_relation_type_id to parts" do
      expect(event.source_relation_type_id).to(eq("parts"))
    end

    it "sets the target_relation_type_id to part_of" do
      expect(event.target_relation_type_id).to(eq("part_of"))
    end
  end

  describe "when relation_type_id is is-part-of" do
    let(:event) do
      build(
        :event,
        subj_id: doi_subj,
        obj_id: doi_obj,
        relation_type_id: "is-part-of",
      )
    end

    before do
      allow(DoiUtilities).to(receive(:uppercase_doi_from_url).with(doi_subj).and_return(doi_subj.upcase))
      allow(DoiUtilities).to(receive(:uppercase_doi_from_url).with(doi_obj).and_return(doi_obj.upcase))

      event.set_source_and_target_doi!
    end

    it "sets the correct source_doi" do
      expect(event.source_doi).to(eq(doi_obj.upcase))
    end

    it "sets the correct target_doi" do
      expect(event.target_doi).to(eq(doi_subj.upcase))
    end

    it "sets the source_relation_type_id to parts" do
      expect(event.source_relation_type_id).to(eq("parts"))
    end

    it "sets the target_relation_type_id to part_of" do
      expect(event.target_relation_type_id).to(eq("part_of"))
    end
  end
end

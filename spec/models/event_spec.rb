# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Event, type: :model) do
  subject(:event) { described_class.new }

  describe "includes" do
    it "RelationTypeHandler" do
      expect(described_class.ancestors).to(include(RelationTypeHandler))
    end

    it "EventIndexHandler" do
      expect(described_class.ancestors).to(include(EventIndexHandler))
    end

    it "EventFromSqsCreator" do
      expect(described_class.ancestors).to(include(EventFromSqsCreator))
    end

    it "EventFromSqsUpdater" do
      expect(described_class.ancestors).to(include(EventFromSqsUpdater))
    end

    it "Elasticsearch::Model" do
      expect(described_class.ancestors).to(include(Elasticsearch::Model))
    end
  end

  describe "attributes" do
    it "uuid" do
      expect(described_class).to(have_attribute(:uuid))
    end

    it "subj_id" do
      expect(described_class).to(have_attribute(:subj_id))
    end

    it "obj_id" do
      expect(described_class).to(have_attribute(:obj_id))
    end

    it "aasm_state" do
      expect(described_class).to(have_attribute(:aasm_state))
    end

    it "state_event" do
      expect(described_class).to(have_attribute(:state_event))
    end

    it "callback" do
      expect(described_class).to(have_attribute(:callback))
    end

    it "error_messages" do
      expect(described_class).to(have_attribute(:error_messages))
    end

    it "source_token" do
      expect(described_class).to(have_attribute(:source_token))
    end

    it "indexed_at" do
      expect(described_class).to(have_attribute(:indexed_at))
    end

    it "occurred_at" do
      expect(described_class).to(have_attribute(:occurred_at))
    end

    it "message_action" do
      expect(described_class).to(have_attribute(:message_action))
    end

    it "subj" do
      expect(described_class).to(have_attribute(:subj))
    end

    it "obj" do
      expect(described_class).to(have_attribute(:obj))
    end

    it "total" do
      expect(described_class).to(have_attribute(:total))
    end

    it "license" do
      expect(described_class).to(have_attribute(:license))
    end

    it "source_doi" do
      expect(described_class).to(have_attribute(:source_doi))
    end

    it "target_doi" do
      expect(described_class).to(have_attribute(:target_doi))
    end

    it "source_relation_type_id" do
      expect(described_class).to(have_attribute(:source_relation_type_id))
    end

    it "target_relation_type_id" do
      expect(described_class).to(have_attribute(:target_relation_type_id))
    end

    it "relation_type_id" do
      expect(described_class).to(have_attribute(:relation_type_id))
    end

    it "source_id" do
      expect(described_class).to(have_attribute(:source_id))
    end
  end

  describe "attribute types" do
    it "uuid is a string" do
      expect(event.uuid).to(be_a(String).or(be_nil))
    end

    it "subj_id is a string" do
      expect(event.subj_id).to(be_a(String).or(be_nil))
    end

    it "obj_id is a string" do
      expect(event.obj_id).to(be_a(String).or(be_nil))
    end

    it "aasm_state is a string" do
      expect(event.aasm_state).to(be_a(String).or(be_nil))
    end

    it "state_event is a string" do
      expect(event.state_event).to(be_a(String).or(be_nil))
    end

    it "callback is a string" do
      expect(event.callback).to(be_a(String).or(be_nil))
    end

    it "error_messages is a string" do
      expect(event.error_messages).to(be_a(String).or(be_nil))
    end

    it "source_token is a string" do
      expect(event.source_token).to(be_a(String).or(be_nil))
    end

    it "indexed_at is a TimeWithZone" do
      expect(event.error_messages).to(be_a(ActiveSupport::TimeWithZone).or(be_nil))
    end

    it "occurred_at is a TimeWithZone" do
      expect(event.occurred_at).to(be_a(ActiveSupport::TimeWithZone).or(be_nil))
    end

    it "message_action is a string" do
      expect(event.message_action).to(be_a(String).or(be_nil))
    end

    it "subj is a string" do
      expect(event.subj).to(be_a(String).or(be_nil))
    end

    it "obj is a string" do
      expect(event.obj).to(be_a(String).or(be_nil))
    end

    it "total is a string" do
      expect(event.total).to(be_a(Integer).or(be_nil))
    end

    it "license is a string" do
      expect(event.license).to(be_a(String).or(be_nil))
    end

    it "source_doi is a string" do
      expect(event.source_doi).to(be_a(String).or(be_nil))
    end

    it "target_doi is a string" do
      expect(event.target_doi).to(be_a(String).or(be_nil))
    end

    it "source_relation_type_id is a string" do
      expect(event.source_relation_type_id).to(be_a(String).or(be_nil))
    end

    it "target_relation_type_id is a string" do
      expect(event.target_relation_type_id).to(be_a(String).or(be_nil))
    end

    it "relation_type_id is a string" do
      expect(event.relation_type_id).to(be_a(String).or(be_nil))
    end

    it "source_id is a string" do
      expect(event.source_id).to(be_a(String).or(be_nil))
    end
  end

  describe "default values" do
    it "has a default value for indexed_at" do
      expect(described_class.new.indexed_at).to(eq(Time.zone.at(0)).or(eq(Time.zone.parse("1970-01-01 00:00:00"))))
    end

    it "has a default value for message_action" do
      expect(described_class.new.message_action).to(eq("create"))
    end

    it "has a default value for total" do
      expect(described_class.new.total).to(eq(1))
    end
  end

  describe "validates" do
    it "uuid presence" do
      expect(event).to(validate_presence_of(:uuid))
    end

    it "subj_id presence" do
      expect(event).to(validate_presence_of(:subj_id))
    end

    it "obj_id presence" do
      expect(event).to(validate_presence_of(:obj_id))
    end

    it "source_id presence" do
      expect(event).to(validate_presence_of(:source_id))
    end

    it "source_token presence" do
      expect(event).to(validate_presence_of(:source_token))
    end

    it "message_action presence" do
      expect(event).to(validate_presence_of(:message_action))
    end

    it "indexed_at presence" do
      expect(event).to(validate_presence_of(:indexed_at))
    end

    it "uuid length" do
      expect(event).to(validate_length_of(:uuid))
    end

    # it "uuid uniqueness" do
    #   expect(event).to(validate_uniqueness_of(:uuid).case_insensitive)
    # end

    it "uuid format" do
      event.uuid = "invalid-uuid"

      expect(event).not_to(be_valid)
    end

    it "message_action length" do
      expect(event).to(validate_length_of(:message_action).is_at_most(191))
    end
  end
end

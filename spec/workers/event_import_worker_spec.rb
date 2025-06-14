# frozen_string_literal: true

require "rails_helper"

RSpec.describe(EventImportWorker, type: :worker) do
  include ActiveSupport::Testing::TimeHelpers

  subject(:worker) { described_class.new }

  let(:valid_event_data) do
    {
      "subjId" => "subj-id",
      "objId" => "obj-id",
      "sourceId" => "source-id",
      "relationTypeId" => "relation-type-id",
    }
  end

  let(:log_prefix) { "[Events:EventImportWorker]" }

  let(:log_identifier) do
    "subj_id: subj-id, obj_id: obj-id, source_id: source-id, relation_type_id: relation-type-id"
  end

  describe ".shoryuken_options" do
    it "uses the correct queue name" do
      queue_option = described_class.get_shoryuken_options["queue"]
      queue = queue_option.respond_to?(:call) ? queue_option.call : queue_option

      expect(queue).to(eq("#{ENV["RAILS_ENV"]}_events"))
    end

    it "uses auto deletes from the sqs queue" do
      queue_option = described_class.get_shoryuken_options["auto_delete"]
      auto_delete = queue_option.respond_to?(:call) ? queue_option.call : queue_option

      expect(auto_delete).to(be(true))
    end
  end

  describe ".perform" do
    let(:worker) { described_class.new }

    it "when data is nil logs error" do
      allow(Rails.logger).to(receive(:error))

      worker.perform(nil, nil)

      expect(Rails.logger).to(have_received(:error).with("[Events:EventImportWorker] Message data was blank"))
    end

    it "when event data is valid builds log identifier" do
      allow(Rails.logger).to(receive(:info))

      allow(worker).to(receive_messages(
        event_data: {},
        log_identifier: "log_identifier",
        find_event: nil,
        create_event: nil,
      ))

      worker.perform(nil, valid_event_data.to_json)

      expect(worker).to(have_received(:log_identifier))
    end

    it "when event data is valid logs process start info message" do
      allow(Rails.logger).to(receive(:info))

      allow(worker).to(receive_messages(
        event_data: {},
        log_identifier: log_identifier,
        find_event: nil,
        create_event: nil,
      ))

      worker.perform(nil, valid_event_data.to_json)

      expect(Rails.logger)
        .to(have_received(:info)
          .with("#{log_prefix} Processing event with #{log_identifier}"))
    end

    it "when event data is valid logs searching for event info message" do
      allow(Rails.logger).to(receive(:info))

      allow(worker).to(receive_messages(
        event_data: {},
        log_identifier: log_identifier,
        find_event: nil,
        create_event: nil,
      ))

      worker.perform(nil, valid_event_data.to_json)

      expect(Rails.logger)
        .to(have_received(:info)
          .with("#{log_prefix} Searching for event with #{log_identifier}"))
    end

    it "when event data is valid searchs for an existing event" do
      allow(Rails.logger).to(receive(:info))

      allow(worker).to(receive_messages(
        event_data: {},
        log_identifier: "log_identifier",
        find_event: nil,
        create_event: nil,
      ))

      worker.perform(nil, valid_event_data.to_json)

      expect(worker).to(have_received(:find_event))
    end

    it "when event data is valid and no event is found sends 'create_event'" do
      allow(Rails.logger).to(receive(:info))

      allow(worker).to(receive_messages(
        event_data: {},
        log_identifier: "log_identifier",
        find_event: nil,
        create_event: nil,
      ))

      worker.perform(nil, valid_event_data.to_json)

      expect(worker).to(have_received(:create_event))
    end

    it "when event data is valid and an event is found sends 'update_event'" do
      allow(Rails.logger).to(receive(:info))

      allow(worker).to(receive_messages(
        event_data: {},
        log_identifier: "log_identifier",
        find_event: build(:event),
        update_event: nil,
      ))

      worker.perform(nil, valid_event_data.to_json)

      expect(worker).to(have_received(:update_event))
    end
  end

  describe ".event_data" do
    it "when data is nil returns nil" do
      expect(worker.send(:event_data, nil)).to(be_nil)
    end

    it "when data is empty string returns nil" do
      expect(worker.send(:event_data, "")).to(be_nil)
    end

    it "when data is valid json but does not contain a key field returns nil" do
      data = { "foo": "bar" }.to_json

      expect(worker.send(:event_data, data)).to(be_nil)
    end

    it "when data is valid json but data value is missing attributes returns nil" do
      data = { "data": { "foo": "bar" } }.to_json

      expect(worker.send(:event_data, data)).to(be_nil)
    end

    it "when data is valid returns the correct value" do
      attributes = { "foo" => "bar" }

      data = {
        "data": {
          "type": "test",
          "attributes": attributes,
        },
      }.to_json

      expect(worker.send(:event_data, data)).to(eq(attributes))
    end
  end

  describe ".log_identifier" do
    it "returns the correct log identifiers" do
      expect(worker.send(:log_identifier, valid_event_data))
        .to(eq("subj_id: subj-id, obj_id: obj-id, source_id: source-id, relation_type_id: relation-type-id"))
    end
  end

  describe ".find_event" do
    it "invokes find_by on the Event model" do
      allow(Event).to(receive(:find_by).and_return(nil))

      worker.send(:find_event, valid_event_data)

      expect(Event)
        .to(have_received(:find_by)
          .with(
            subj_id: valid_event_data["subjId"],
            obj_id: valid_event_data["objId"],
            source_id: valid_event_data["sourceId"],
            relation_type_id: valid_event_data["relationTypeId"],
          ))
    end

    it "if event is not found returns nil" do
      allow(Event).to(receive(:find_by).and_return(nil))

      expect(worker.send(:find_event, valid_event_data)).to(be_nil)
    end

    it "if event is found returns an Event model instance" do
      event = build(:event)

      allow(Event).to(receive(:find_by).and_return(event))

      expect(worker.send(:find_event, valid_event_data)).to(be_a(Event))
    end
  end

  describe ".create_event" do
    let(:event) { build(:event) }

    it "logs the initial creating 'info' message" do
      allow(Rails.logger).to(receive(:info))

      allow(Event).to(receive(:create_instance_from_sqs).and_return(event))

      allow(event).to(receive(:save).and_return(true))

      worker.send(:create_event, valid_event_data, log_prefix, log_identifier)

      expect(Rails.logger)
        .to(have_received(:info)
          .with("#{log_prefix} Creating event with #{log_identifier}"))
    end

    it "sends 'create_instance_from_sqs' to the Event model" do
      allow(Rails.logger).to(receive(:info))

      allow(Event).to(receive(:create_instance_from_sqs).and_return(event))

      allow(event).to(receive(:save).and_return(true))

      worker.send(:create_event, valid_event_data, log_prefix, log_identifier)

      expect(Event).to(have_received(:create_instance_from_sqs))
    end

    it "sends 'save' to the event instance" do
      allow(Rails.logger).to(receive(:info))

      allow(Event).to(receive(:create_instance_from_sqs).and_return(event))

      allow(event).to(receive(:save).and_return(true))

      worker.send(:create_event, valid_event_data, log_prefix, log_identifier)

      expect(event).to(have_received(:save))
    end

    it "when event saving failed logs the error message" do
      allow(Rails.logger).to(receive(:error))

      allow(event).to(receive(:save).and_return(false))

      allow(event.errors).to(receive(:any?).and_return(true))

      allow(Event).to(receive(:create_instance_from_sqs).and_return(event))

      worker.send(:create_event, valid_event_data, log_prefix, log_identifier)

      expect(Rails.logger).to(have_received(:error))
    end

    it "when event saving fails due to RecordNotUnique logs the error message" do
      allow(Rails.logger).to(receive(:info))

      allow(Rails.logger).to(receive(:error))

      allow(Event).to(receive(:create_instance_from_sqs).and_return(event))

      allow(event).to(receive(:save).and_raise(ActiveRecord::RecordNotUnique))

      worker.send(:create_event, valid_event_data, log_prefix, log_identifier)

      expect(Rails.logger)
        .to(have_received(:error)
          .with("#{log_prefix} Event with #{log_identifier} already exists, skipping creation"))
    end

    it "when event saving succeeded logs the info message" do
      allow(Rails.logger).to(receive(:info))

      allow(event).to(receive(:save).and_return(true))

      allow(Event).to(receive(:create_instance_from_sqs).and_return(event))

      worker.send(:create_event, valid_event_data, log_prefix, log_identifier)

      expect(Rails.logger)
        .to(have_received(:info)
          .with("#{log_prefix} Successfully created event with #{log_identifier}"))
    end
  end

  describe ".update_event" do
    let(:event) { Event.new }

    it "logs the initial creating 'info' message" do
      allow(Rails.logger).to(receive(:info))

      allow(event).to(receive(:update_instance_from_sqs))

      allow(event).to(receive(:save).and_return(true))

      worker.send(:update_event, event, valid_event_data, log_prefix, log_identifier)

      expect(Rails.logger)
        .to(have_received(:info)
          .with("#{log_prefix} Updating event with #{log_identifier}"))
    end

    it "sends 'update_instance_from_sqs' to the Event model" do
      allow(Rails.logger).to(receive(:info))

      allow(event).to(receive(:save).and_return(true))

      allow(event).to(receive(:update_instance_from_sqs))

      worker.send(:update_event, event, valid_event_data, log_prefix, log_identifier)

      expect(event).to(have_received(:update_instance_from_sqs))
    end

    it "sends 'save' to the event instance" do
      allow(Rails.logger).to(receive(:info))

      allow(event).to(receive_messages(
        update_instance_from_sqs: nil,
        save: true,
      ))

      worker.send(:update_event, event, valid_event_data, log_prefix, log_identifier)

      expect(event).to(have_received(:save))
    end

    it "when event saving failed logs the error message" do
      allow(Rails.logger).to(receive(:error))

      allow(event).to(receive_messages(
        save: false,
        update_instance_from_sqs: nil,
      ))

      allow(event.errors).to(receive(:any?).and_return(true))

      worker.send(:update_event, event, valid_event_data, log_prefix, log_identifier)

      expect(Rails.logger).to(have_received(:error))
    end

    it "when event saving succeeded logs the info message" do
      allow(Rails.logger).to(receive(:info))

      allow(event).to(receive_messages(
        save: true,
        update_instance_from_sqs: nil,
      ))

      worker.send(:update_event, event, valid_event_data, log_prefix, log_identifier)

      expect(Rails.logger)
        .to(have_received(:info)
          .with("#{log_prefix} Successfully updated event with #{log_identifier}"))
    end
  end
end

# frozen_string_literal: true

module EventFactory
  class << self
    # Creates and returns an event from the dequeued message from the events SQS queue.
    def create_instance_from_sqs(message)
      Event.new(
        uuid: message["uuid"] || SecureRandom.uuid,
        subj_id: DoiUtilities.normalize_doi(message["subjId"]) || message["subjId"],
        obj_id: DoiUtilities.normalize_doi(message["objId"]) || message["objId"],
        source_id: message["sourceId"],
        aasm_state: "waiting",
        source_token: message["sourceToken"],
        total: message["total"] || 1,
        occurred_at: message["occurredAt"] || Time.now.utc,
        message_action: message["messageAction"] || "create",
        relation_type_id: message["relationTypeId"] || "references",
        subj: message["subj"]&.to_json,
        obj: message["obj"]&.to_json,
        license: message["license"] || "https://creativecommons.org/publicdomain/zero/1.0/",
      )
    end

    # Updates attributes of and returns an event from the dequeued message from the events SQS queue.
    def update_instance_from_sqs(event, message)
      event.uuid = message["uuid"] if message["uuid"].present?
      event.source_id = message["sourceId"] if message["sourceId"].present?
      event.source_token = message["sourceToken"] if message["sourceToken"].present?
      event.total = message["total"] if message["total"].present?
      event.occurred_at = message["occurred_at"] if message["occurred_at"].present?
      event.relation_type_id = message["relation_type_id"] if message["relation_type_id"].present?
      event.subj = message["subj"].to_json if message["subj"].present?
      event.obj = message["obj"].to_json if message["obj"].present?
      event.license = message["license"] if message["license"].present?

      if message["subj_id"].present?
        event.subj_id = DoiUtilities.normalize_doi(message["subjId"]) || message["subjId"]
      end

      if ["obj_id"].present?
        event.obj_id = DoiUtilities.normalize_doi(message["objId"]) || message["objId"]
      end
    end
  end
end

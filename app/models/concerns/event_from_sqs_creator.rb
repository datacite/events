# frozen_string_literal: true

module EventFromSqsCreator
  extend ActiveSupport::Concern

  # Creates Event model instance from dequeued message from the events SQS queue.
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
end

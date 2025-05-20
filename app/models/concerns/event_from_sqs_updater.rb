# frozen_string_literal: true

module EventFromSqsUpdater
  extend ActiveSupport::Concern

  class << self
    # Updates attributes of an instance of the Event model from the dequeued message from the events SQS queue.
    def update_instance_from_sqs(event, message)
      event.uuid = message["uuid"] if message["uuid"].present?
      event.source_id = message["sourceId"] if message["sourceId"].present?
      event.source_token = message["sourceToken"] if message["sourceToken"].present?
      event.total = message["total"] if message["total"].present?
      event.occurred_at = message["occurredAt"] if message["occurredAt"].present?
      event.relation_type_id = message["relationTypeId"] if message["relationTypeId"].present?
      event.subj = message["subj"].to_json if message["subj"].present?
      event.obj = message["obj"].to_json if message["obj"].present?
      event.license = message["license"] if message["license"].present?

      if message["subjId"].present?
        event.subj_id = DoiUtilities.normalize_doi(message["subjId"]) || message["subjId"]
      end

      if message["objId"].present?
        event.obj_id = DoiUtilities.normalize_doi(message["objId"]) || message["objId"]
      end
    end
  end
end

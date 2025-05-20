# frozen_string_literal: true

module EventFromSqsUpdater
  extend ActiveSupport::Concern

  # Updates attributes of an instance of the Event model from the dequeued message from the events SQS queue.
  def update_instance_from_sqs(message)
    self.uuid = message["uuid"] if message["uuid"].present?
    self.source_id = message["sourceId"] if message["sourceId"].present?
    self.source_token = message["sourceToken"] if message["sourceToken"].present?
    self.total = message["total"] if message["total"].present?
    self.occurred_at = message["occurredAt"] if message["occurredAt"].present?
    self.relation_type_id = message["relationTypeId"] if message["relationTypeId"].present?
    self.subj = message["subj"].to_json if message["subj"].present?
    self.obj = message["obj"].to_json if message["obj"].present?
    self.license = message["license"] if message["license"].present?

    if message["subjId"].present?
      self.subj_id = DoiUtilities.normalize_doi(message["subjId"]) || message["subjId"]
    end

    if message["objId"].present?
      self.obj_id = DoiUtilities.normalize_doi(message["objId"]) || message["objId"]
    end
  end
end

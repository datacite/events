module EventFactory
  # Creates and returns an event from the dequeued message from the events SQS queue.
  def self.create_from_sqs(message)
    now = Time.now.utc

    Event.new(
      uuid: message["uuid"] || SecureRandom.uuid,
      subj_id: DoiUtilities.normalize_doi(message["subjId"]) || message["subjId"],
      obj_id: DoiUtilities.normalize_doi(message["objId"]) || message["objId"],
      source_id: message["sourceId"],
      aasm_state: "waiting",
      source_token: message["sourceToken"],
      created_at: now,
      updated_at: now,
      total: message["total"] || 1,
      occurred_at: message["occurred_at"] || now,
      message_action: "create",
      relation_type_id: message["relation_type_id"] || "references",
      subj: message["subj"].to_json,
      obj: message["obj"].to_json,
      license: message["license"] || "https://creativecommons.org/publicdomain/zero/1.0/",
    )
  end
end

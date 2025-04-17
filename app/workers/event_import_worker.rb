# frozen_string_literal: true

# The EventImportWorker subscribes to the events queue (with environment prefix i.e. stage_events production_events).
# It deqeues a message from the events queue.
# Determines if the event exists:
#   If the event does not exist, we create a new event (mysql and opensearch)
#   If the event does exist, we update the existing event (mysql and opensearch)
class EventImportWorker
  include Shoryuken::Worker

  # Ensures that we use the rails environment on our queue prefix
  shoryuken_options queue: -> { "#{ENV["RAILS_ENV"]}_events" }, auto_delete: true

  def perform(sqs_message = nil, data = nil)
    log_prefix = "[Events:EventImportWorker]"
    log_identifier = "subj_id: #{data["subjId"]}, " \
      "obj_id: #{data["objId"]}, " \
      "source_id: #{data["sourceId"]}, " \
      "relation_type_id: #{data["relationTypeId"]}"

    Rails.logger.info("#{log_prefix} Start of event message processing for #{log_identifier}")
    Rails.logger.info("#{log_prefix} Searching for event with #{log_identifier}")

    event = Event.find_by(
      sub_id: data["subjId"],
      obj_id: data["objId"],
      source_id: data["sourceId"],
      relation_type_id: data["relationTypeId"],
    )

    if event.blank?
      Rails.logger.info("#{LOG_PREFIX} Creating a new event with #{log_identifier}")
      # create the event in mysql
      # and index the event
    else
      Rails.logger.info("#{LOG_PREFIX} Update an existing event with #{log_identifier}")
      # update the event in mysql
      # and index the event
    end

    Rails.logger.info("#{LOG_PREFIX} Update existing event with #{log_identifier}")
  end
end

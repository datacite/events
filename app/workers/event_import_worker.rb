# frozen_string_literal: true

class EventImportWorker
  include Shoryuken::Worker

  shoryuken_options queue: -> { "#{ENV["RAILS_ENV"]}_events" }, auto_delete: true

  def perform(sqs_message = nil, data = nil)
    log_prefix = "[Events:EventImportWorker]"

    if data.blank?
      Rails.logger.info("#{log_prefix} Message data was blank")
      return
    end

    log_identifier = "subj_id: #{data["subjId"]}, " \
      "obj_id: #{data["objId"]}, " \
      "source_id: #{data["sourceId"]}, " \
      "relation_type_id: #{data["relationTypeId"]}"

    Rails.logger.info("#{log_prefix} Start of event message processing for #{log_identifier}")
    Rails.logger.info("#{log_prefix} Searching for event with #{log_identifier}")

    event = Event.find_by(
      subj_id: data["subjId"],
      obj_id: data["objId"],
      source_id: data["sourceId"],
      relation_type_id: data["relationTypeId"],
    )

    if event.blank?
      Rails.logger.info("#{log_prefix} Creating a new event with #{log_identifier}")
    else
      Rails.logger.info("#{log_prefix} Update an existing event with #{log_identifier}")
    end

    Rails.logger.info("#{log_prefix} End of event message processing for #{log_identifier}")
  end
end

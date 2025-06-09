# frozen_string_literal: true

class EventImportWorker
  include Shoryuken::Worker

  shoryuken_options queue: -> { "#{ENV["RAILS_ENV"]}_events" }, auto_delete: true

  def perform(sqs_message = nil, data = nil)
    log_prefix = "[Events:EventImportWorker]"

    event_data = event_data(data)

    if event_data.nil?
      Rails.logger.error("#{log_prefix} Message data was blank")
      return
    end

    log_identifier = log_identifier(event_data)

    Rails.logger.info("#{log_prefix} Processing event with #{log_identifier}")
    Rails.logger.info("#{log_prefix} Searching for event with #{log_identifier}")

    event = find_event(event_data)

    if event.nil?
      create_event(event_data, log_prefix, log_identifier)
    else
      update_event(event, event_data, log_prefix, log_identifier)
    end

    Rails.logger.info("#{log_prefix} Completed processing event for #{log_identifier}")
  end

  private

  # Returns the SQS event data as a hash.
  # Will return nil if either a data or attributes field is missing.
  def event_data(data)
    return if data.blank?

    data_hash = JSON.parse(data)

    data_hash.dig("data", "attributes")
  end

  # Returns a string which serves as an identifier for this event import worker run.
  # Consists of the event subj_id, obj_id, source_id and relation_type_id.
  def log_identifier(event_data)
    "subj_id: #{event_data["subjId"]}, " \
      "obj_id: #{event_data["objId"]}, " \
      "source_id: #{event_data["sourceId"]}, " \
      "relation_type_id: #{event_data["relationTypeId"]}"
  end

  # Searchs for an existing event using subj_id, obj_id, source_id and relation_type_id
  def find_event(event_data)
    Event.find_by(
      subj_id: event_data["subjId"],
      obj_id: event_data["objId"],
      source_id: event_data["sourceId"],
      relation_type_id: event_data["relationTypeId"],
    )
  end

  def create_event(event_data, log_prefix, log_identifier)
    Rails.logger.info("#{log_prefix} Creating event with #{log_identifier}")

    event = Event.create_instance_from_sqs(event_data)

    if event.save
      Rails.logger.info("#{log_prefix} Successfully created event with #{log_identifier}")
    elsif event.errors.any?
      Rails.logger.error("#{log_prefix} Failed to create event with #{log_identifier}: #{event.errors.inspect}")
    end
  rescue ActiveRecord::RecordNotUnique
    Rails.logger.error("#{log_prefix} Event with #{log_identifier} already exists, skipping creation")
  end

  def update_event(event, event_data, log_prefix, log_identifier)
    Rails.logger.info("#{log_prefix} Updating event with #{log_identifier}")

    event.update_instance_from_sqs(event_data)

    if event.save
      Rails.logger.info("#{log_prefix} Successfully updated event with #{log_identifier}")
    else
      Rails.logger.error("#{log_prefix} Failed to updated event with #{log_identifier}: #{event.errors.inspect}")
    end
  end
end

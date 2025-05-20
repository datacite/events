# frozen_string_literal: true

class EventImportWorker
  include Shoryuken::Worker

  shoryuken_options queue: -> { "#{ENV["RAILS_ENV"]}_events" }, auto_delete: true

  def perform(sqs_message = nil, data = nil)
    log_prefix = "[Events:EventImportWorker]"

    event_data = event_data(data)

    if event_data.nil?
      Rails.logger.info("#{log_prefix} Message data was blank")
      return
    end

    log_identifier = log_identifier(event_data)

    Rails.logger.info("#{log_prefix} Start of event message processing for #{log_identifier}")
    Rails.logger.info("#{log_prefix} Searching for event for #{log_identifier}")

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
    Rails.logger.info("#{log_prefix} Creating a new event for #{log_identifier}")

    event = Event.create_instance_from_sqs(event_data)

    if event.save
      Rails.logger.info("#{log_prefix} Event successfully created for #{log_identifier}")
    elsif event.errors.any?
      Rails.logger.error("#{log_prefix} Creating event failed for #{log_identifier}: #{event.errors.inspect}")
    end
  end

  def update_event(event, event_data, log_prefix, log_identifier)
    Rails.logger.info("#{log_prefix} Update an existing event for #{log_identifier}")

    Event.update_instance_from_sqs(event, event_data)

    if event.save
      Rails.logger.info("#{log_prefix} Event successfully updated for #{log_identifier}")
    else
      Rails.logger.error("#{log_prefix} Updating event failed for #{log_identifier}: #{event.errors.inspect}")
    end
  end
end

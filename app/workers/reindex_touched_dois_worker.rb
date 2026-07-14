class ReindexTouchedDoisWorker
  include Shoryuken::Worker

  shoryuken_options queue: -> { "#{ENV["RAILS_ENV"]}_events_reindex_daily" }, auto_delete: true

  def perform(sqs_message = nil, data = nil)
    log_prefix = "[Events:ReindexTouchedDoisWorker]"
    Rails.logger.info("#{log_prefix} Received message body: #{sqs_message.body}")
    Rails.logger.info("#{log_prefix} Received message data: #{data}")

    date = get_date(data)

    Rails.logger.info("#{log_prefix} Starting reindex of DOIs touched on #{date}")

    if date.nil?
      Rails.logger.error("#{log_prefix} Date was not provided")
      return
    end

    # Reindex touched DOIS
    count = Event.reindex_touched_dois(start_date: date, end_date: date)

    Rails.logger.info("#{log_prefix} Sent #{count} unique DOIs for re-indexing on #{date}")
  end

  private

  # Will return nil if either data or date field is missing.
  def get_date(data)
    return if data.blank?

    data_hash = JSON.parse(data)
    data_hash.dig("date")

    begin
      Date.parse(date)
    rescue
      nil
    end
  end
end

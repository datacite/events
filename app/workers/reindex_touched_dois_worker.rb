class ReindexTouchedDoisWorker
  include Shoryuken::Worker

  shoryuken_options queue: -> { "#{ENV["RAILS_ENV"]}_events_reindex_daily" }, auto_delete: true

  def perform(sqs_message = nil, data = nil)
    log_prefix = "[Events:ReindexTouchedDoisWorker]"

    date = JSON.parse(data).dig("date")
    Rails.logger.error("#{log_prefix} data date: #{date}")
    date = Date.parse(date)
    Rails.logger.error("#{log_prefix} parsed date: #{date}")

    if date.nil?
      Rails.logger.error("#{log_prefix} Date was not provided")
      return
    end

    Rails.logger.info("#{log_prefix} Starting reindex of DOIs touched on #{date}")

    # Reindex touched DOIS
    count = Event.reindex_touched_dois(start_date: date, end_date: date)

    Rails.logger.info("#{log_prefix} Sent #{count} unique DOIs for re-indexing on #{date}")
  end
end

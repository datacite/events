class ReindexTouchedDoisWorker
  include Shoryuken::Worker

  shoryuken_options queue: -> { "#{ENV["RAILS_ENV"]}_events" }, auto_delete: true

  def perform(sqs_message = nil, data = nil)
    log_prefix = "[Events:ReindexTouchedDoisWorker]"

    date = get_date(data)
    date = Date.parse(date) rescue nil

    if date.nil?
      Rails.logger.error("#{log_prefix} Date was blank")
      return
    end


    # Reindex touched DOIS
    count = Event.reindex_touched_dois(start_date: date, end_date: start_date)

    Rails.logger.info("#{log_prefix} Sent #{count} unique DOIs for re-indexing on #{date}")
  end

  private

  # Will return nil if either data or date field is missing.
  def get_date(data)
    return if data.blank?

    data_hash = JSON.parse(data)
    data_hash.dig("data", "date")
  end
end

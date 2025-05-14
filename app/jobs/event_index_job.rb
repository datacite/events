# frozen_string_literal: true

class EventIndexJob < ApplicationJob
  queue_as :events_index

  rescue_from ActiveJob::DeserializationError,
    SocketError,
    Elasticsearch::Transport::Transport::Errors::BadRequest,
    Elasticsearch::Transport::Transport::Error do |error|
    Rails.logger.error(error.message)
  end

  def perform(obj)
    log_prefix = "[Events:EventIndexJob]"

    response = obj.__elasticsearch__.index_document

    if ["created", "updated"].exclude?(response["result"])
      Rails.logger.error("#{log_prefix} OpenSearch Error: #{response.inspect}")
    end
  end
end

# frozen_string_literal: true

module Queueable
  extend ActiveSupport::Concern

  require "aws-sdk-sqs"

  class_methods do
    def send_events_other_doi_job_message(data)
      send_message(data, shoryuken_class: "OtherDoiJobWorker", queue_name: "events_other_doi_job")
    end

    private

    def send_message(body, options = {})
      sqs = create_sqs_client
      queue_name_prefix = ENV["SQS_PREFIX"].presence || Rails.env
      queue_url = sqs.get_queue_url(queue_name: "#{queue_name_prefix}_#{options[:queue_name]}").queue_url

      options = {
        queue_url: queue_url,
        message_attributes: {
          "shoryuken_class" => {
            string_value: options[:shoryuken_class],
            data_type: "String",
          },
        },
        message_body: body.to_json,
      }

      sqs.send_message(options)
    rescue => error
      Rails.logger.error("Failed to send message to #{queue_url}. #{error.inspect}.")
    end

    def create_sqs_client
      if Rails.env.development?
        Aws::SQS::Client.new(endpoint: ENV["AWS_ENDPOINT"])
      else
        Aws::SQS::Client.new
      end
    end
  end
end

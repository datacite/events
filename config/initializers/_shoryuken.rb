# frozen_string_literal: true

if Rails.env.development?
  Aws.config.update({
    endpoint: ENV["AWS_ENDPOINT"],
    region: "us-east-1",
    credentials: Aws::Credentials.new("test", "test"),
  })
end

Shoryuken.active_job_queue_name_prefixing = true

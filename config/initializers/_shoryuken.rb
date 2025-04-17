# frozen_string_literal: true

if Rails.env.development?
  Aws.config.update({
    endpoint: ENV["AWS_ENDPOINT"],
    region: ENV["AWS_REGION"],
    credentials: Aws::Credentials.new(ENV["AWS_ACCESS_KEY"], ENV["AWS_SECRET_ACCESS_KEY"]),
  })
end

Shoryuken.active_job_queue_name_prefixing = true

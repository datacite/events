# frozen_string_literal: true

if Rails.env.development?
  Aws.config.update({
    endpoint: ENV["AWS_ENDPOINT"],
    region: ENV["AWS_REGION"],
    credentials: Aws::Credentials.new(ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"]),
  })
end

# This ensures that we work with queues that
# have an environment prefix i.e. stage_events or development_events
Shoryuken.active_job_queue_name_prefixing = true

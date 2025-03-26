# frozen_string_literal: true

if Rails.env.development?
  Aws.config.update({
    endpoint: ENV["AWS_ENDPOINT"],
    region: "us-east-1",
    credentials: Aws::Credentials.new("test", "test"),
  })
end

# Shoryuken middleware to capture worker errors and send them on to Sentry.io
# module Shoryuken
#   module Middleware
#     module Server
#       class RavenReporter
#         def call(_worker_instance, queue, _sqs_msg, body, &block)
#           tags = { job: body["job_class"], queue: queue }
#           context = { message: body }
#           Raven.capture(tags: tags, extra: context, &block)
#         end
#       end
#     end
#   end
# end

Shoryuken.active_job_queue_name_prefixing = true

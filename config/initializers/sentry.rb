# frozen_string_literal: true

Sentry.init do |config|
  config.environments = ["stage", "production"]
  config.dsn = ENV["SENTRY_DSN"]
  config.release = "events:" + Events::Application::VERSION
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.logger = Rails.application.config.lograge.logger
end
# Raven.configure do |config|
#   config.environments = ["stage", "production"]
#   config.dsn = ENV["SENTRY_DSN"]
#   config.release = "events:" + Events::Application::VERSION
#   config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
#   config.logger = Rails.application.config.lograge.logger
# end

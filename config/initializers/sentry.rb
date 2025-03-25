# frozen_string_literal: true

Raven.configure do |config|
  config.environments = ["stage", "production"]
  config.dsn = ENV["SENTRY_DSN"]
  config.release = "events:" + Events::Application::VERSION
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.logger = Rails.application.config.lograge.logger
end

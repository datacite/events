# frozen_string_literal: true

Sentry.init do |config|
  config.enabled_environments = ["stage", "production"]
  config.dsn = ENV["SENTRY_DSN"]
  config.release = "events:" + Events::Application::VERSION
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.logger = Rails.application.config.lograge.logger
  config.send_default_pii = true

  filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)

  config.before_send = lambda do |event, _hint|
    if event.extra
      event.extra = filter.filter(event.extra)
    end

    if event.user
      event.user = filter.filter(event.user)
    end

    if event.contexts
      event.contexts = filter.filter(event.contexts)
    end

    event
  end
end
# Raven.configure do |config|
#   config.environments = ["stage", "production"]
#   config.dsn = ENV["SENTRY_DSN"]
#   config.release = "events:" + Events::Application::VERSION
#   config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
#   config.logger = Rails.application.config.lograge.logger
# end

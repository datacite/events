# frozen_string_literal: true

Datadog.configure do |c|
  # Global
  c.agent.host = "datadog.local"
  c.runtime_metrics.enabled = true
  c.service = "events"
  c.env = Rails.env

  # Tracing settings

  # Enable tracing for production and staging envs
  c.tracing.enabled = Rails.env.production? || ENV["RAILS_ENV"] == "stage"

  # We disable automatic log injection because it doesn't play nice with our formatter
  c.tracing.log_injection = false

  # Instrumentation
  c.tracing.instrument :rails
  c.tracing.instrument :elasticsearch
  c.tracing.instrument :shoryuken
  c.tracing.instrument :graphql, enabled: false, with_deprecated_tracers: true

  # Profiling setup
  c.profiling.enabled = ENV["RAILS_ENV"] == "stage"
end if defined?(Datadog)

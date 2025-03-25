# frozen_string_literal: true

require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

env_file = File.expand_path("../.env", __dir__)

if File.exist?(env_file)
  require "dotenv"
  Dotenv.load!(env_file)
end

env_json_file = "/etc/container_environment.json"
if File.exist?(env_json_file)
  env_vars = JSON.parse(File.read(env_json_file))
  env_vars.each { |k, v| ENV[k] = v }
end

module Events
  class Application < Rails::Application
    config.load_defaults(7.1)

    config.autoload_lib(ignore: nil)

    config.api_only = true

    config.middleware.use(Rack::Deflater)

    config.active_job.logger = Logger.new(nil)

    config.secret_key_base = "blipblapblup"

    # Start: Configure Logging
    config.lograge.enabled = true
    config.lograge.formatter = Lograge::Formatters::Logstash.new
    config.lograge.logger = LogStashLogger.new(type: :stdout)
    config.logger = config.lograge.logger ## LogStashLogger needs to be pass to rails logger, see roidrage/lograge#26
    config.log_level = ENV["LOG_LEVEL"].to_sym

    config.lograge.ignore_actions = [
      "HeartbeatController#index",
      "IndexController#index",
    ]
    config.lograge.ignore_custom = lambda do |event|
      event.payload.inspect.length > 100_000
    end
    config.lograge.base_controller_class = "ActionController::API"

    config.lograge.custom_options = lambda do |event|
      correlation = Datadog::Tracing.correlation
      exceptions = ["controller", "action", "format", "id"]
      {
        dd: {
          env: correlation.env,
          service: correlation.service,
          version: correlation.version,
          trace_id: correlation.trace_id,
          span_id: correlation.span_id,
        },
        ddsource: ["ruby"],
        params: event.payload[:params].except(*exceptions),
        uid: event.payload[:uid],
      }
    end
    # End: Configure Logging
  end
end

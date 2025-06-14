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

ENV["GITHUB_URL"] ||= "https://github.com/datacite/events"

module Events
  class Application < Rails::Application
    config.load_defaults(7.1)

    config.autoload_lib(ignore: nil)

    # Autoload paths
    # You typically add directories to autoload_paths so that classes and modules are loaded
    # automatically as they are referenced. This makes development more convenient
    # config.autoload_paths += %W(#{config.root}/app/models/concerns)

    # Eager load paths
    # You typically add directories to eager_load_paths to ensure that all necessary classes
    # and modules are loaded at startup, improving performance in production.
    # config.eager_load_paths << "#{config.root}/app/workers"

    config.api_only = true

    config.middleware.use(Rack::Deflater)

    config.secret_key_base = "blipblapblup"

    config.active_job.logger = Rails.logger

    config.logger = Logger.new($stdout)
    config.log_level = :info

    config.active_job.queue_adapter = :shoryuken
    config.active_job.queue_name_prefix = Rails.env
  end
end

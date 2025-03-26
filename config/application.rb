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

    config.api_only = true

    config.middleware.use(Rack::Deflater)

    config.active_job.logger = Logger.new(nil)

    config.secret_key_base = "blipblapblup"

    config.logger = Logger.new($stdout)
    config.log_level = :info
  end
end

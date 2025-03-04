require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

env_file = File.expand_path("../.env", __dir__)

if File.exist?(env_file)
  require "dotenv"
  Dotenv.load!(env_file)
end

unless Rails.env.development?
  if File.exist?(env_json_file)
    env_vars = JSON.parse(File.read("/etc/container_environment.json"))
    env_vars.each { |k, v| ENV[k] = v }
  end
end

module Events
  class Application < Rails::Application
    config.load_defaults 7.1

    config.autoload_lib(ignore: nil)

    config.api_only = true

    config.middleware.use Rack::Deflater
  end
end

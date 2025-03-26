# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.1.6"

gem "rails", "~> 7.1.3", ">= 7.1.3.2"
gem "bootsnap", require: false
gem "rack-cors"
gem "datadog", require: "datadog/auto_instrument"
gem "shoryuken", "~> 4.0"
gem "aws-sdk-sqs", "~> 1.3"
gem "lograge", "~> 0.11.2"
gem "logstash-event", "~> 1.2", ">= 1.2.02"
gem "logstash-logger", "~> 0.26.1"
gem "mysql2", "~> 0.5.3"
gem "dotenv"
gem "sentry-ruby"
gem "sentry-rails"
gem "elasticsearch", "~> 7.17", ">= 7.17.10"
gem "elasticsearch-model", "~> 7.2.1", ">= 7.2.1", require: "elasticsearch/model"
gem "elasticsearch-rails", "~> 7.2.1", ">= 7.2.1"
gem "elasticsearch-transport", "~> 7.17", ">= 7.17.10"
gem "git", "~> 1.5"

# This gem will allow us to write tests without the need for a database
gem "activerecord-nulldb-adapter", "~> 1.1", ">= 1.1.1"

group :development, :test do
  gem "debug", platforms: [:mri, :windows]
  gem "rubocop", require: false
  gem "rubocop-shopify", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-rails", require: false
  gem "factory_bot_rails", require: false
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rspec-rails", "~> 7.0.0"
end

group :development do
end

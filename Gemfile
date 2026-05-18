source "https://rubygems.org"

ruby "4.0.1"

gem "rails", "~> 8.1", ">= 8.1.2.1"
gem "addressable", "~> 2.8", ">= 2.8.9"
gem "bootsnap", "~> 1.23", require: false
gem "rack-cors", "~> 3.0"
gem "shoryuken", "~> 7.0", ">= 7.0.1"
gem "aws-sdk-sqs", "~> 1.112"
gem "lograge", "~> 0.14.0"
gem "logstash-logger", "~> 1.0"
gem "mysql2", "~> 0.5.7"
gem "dotenv", "~> 3.2"
gem "sentry-ruby", "~> 6.5"
gem "sentry-rails", "~> 6.5"
gem "elasticsearch", "~> 8.19", ">= 8.19.3"
gem "elasticsearch-model", "~> 8.0", ">= 8.0.1", require: "elasticsearch/model"
gem "elasticsearch-rails", "~> 8.0", ">= 8.0.1"
gem "elastic-transport", "~> 8.0", ">= 8.0.1"
gem "faraday", "~> 2.14", ">= 2.14.1"
gem "faraday_middleware-aws-sigv4", "~> 1.0", ">= 1.0.1"
gem "faraday-excon", "~> 2.4"
gem "uuid", "~> 2.3", ">= 2.3.9"
gem "oj", "~> 3.16", ">= 3.16.16"
gem "parallel", "~> 1.27"

group :development, :test do
  gem "debug", "~> 1.11", ">= 1.11.1", platforms: [:mri, :windows]
  gem "rubocop", "~> 1.86", require: false
  gem "rubocop-shopify", "~> 2.18", require: false
  gem "rubocop-rspec", "~> 3.9", require: false
  gem "rubocop-performance", "~> 1.26", ">= 1.26.1", require: false
  gem "rubocop-factory_bot", "~> 2.28", require: false
  gem "rubocop-rails", "~> 2.34", ">= 2.34.3", require: false
  gem "rubocop-rspec_rails", "~> 2.32", require: false
  gem "factory_bot_rails", "~> 6.5", ">= 6.5.1"
  gem "bundler-audit", "~> 0.9.3", require: false
  gem "brakeman", "~> 8.0", ">= 8.0.4", require: false
  gem "rspec-rails", "~> 8.0", ">= 8.0.4"
end

group :test do
  gem "simplecov", "~> 0.22.0", require: false
  gem "shoulda-matchers", "~> 7.0", ">= 7.0.1"
  gem "coveralls_reborn", "~> 0.29.0", require: false
  gem "activerecord-nulldb-adapter", "~> 1.2", ">= 1.2.2" # This gem will allow us to write tests without the need for a database
end

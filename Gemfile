source "https://rubygems.org"

ruby "4.0.1"

gem "rails", "~> 8.1", ">= 8.1.2.1"
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
  gem "debug", platforms: [:mri, :windows]
  gem "rubocop", require: false
  gem "rubocop-shopify", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec_rails", require: false
  gem "factory_bot_rails"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rspec-rails", "~> 7.0.0"
end

group :test do
  gem "simplecov", require: false
  gem "shoulda-matchers"
  gem "coveralls_reborn", require: false
  gem "activerecord-nulldb-adapter", "~> 1.2", ">= 1.2.2" # This gem will allow us to write tests without the need for a database
end

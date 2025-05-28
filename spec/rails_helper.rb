# frozen_string_literal: true

require "simplecov"
require "coveralls"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter,
])

require "simplecov"
SimpleCov.start("rails")

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"
require "shoulda/matchers"

# TODO: add this back when you create the new events database
# begin
#   ActiveRecord::Migration.maintain_test_schema!
# rescue ActiveRecord::PendingMigrationError => e
#   abort(e.to_s.strip)
# end

RSpec.configure do |config|
  # Before each test run set the queue adapter to test.
  # This will allow use to test ActiveJob instances.
  config.before(:suite) do
    ActiveJob::Base.queue_adapter = :test
  end

  config.fixture_paths = [
    Rails.root.join("spec/fixtures"),
  ]

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  # Configure factory bot
  config.include(FactoryBot::Syntax::Methods)
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework(:rspec)
    with.library(:rails)
  end
end

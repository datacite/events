# frozen_string_literal: true

require "rails_helper"

RSpec.describe(EventIndexJob, type: :job) do
  describe ".shoryuken_options" do
    it "uses the correct queue name" do
      queue_name = "#{ENV["RAILS_ENV"]}_events_index"
      expect { described_class.perform_later({}) }.to(have_enqueued_job(described_class).on_queue(queue_name))
    end
  end
end

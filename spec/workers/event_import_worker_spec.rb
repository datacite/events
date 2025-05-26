# frozen_string_literal: true

require "rails_helper"

RSpec.describe(EventImportWorker, type: :worker) do
  include ActiveSupport::Testing::TimeHelpers

  describe "foo" do
    it "bar" do
      one = 1

      expect(one).to(eq(1))
    end
  end
end

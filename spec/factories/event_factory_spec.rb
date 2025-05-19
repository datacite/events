# frozen_string_literal: true

require "rails_helper"

RSpec.describe("EventFactory") do
  describe "#create_instance_from_sqs" do
    it "does some stuff" do
      e = Event.new
      puts(e)
      name = "test"
      expect(name).to(eq("test"))
    end
  end
end

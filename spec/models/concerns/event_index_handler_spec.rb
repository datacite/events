# frozen_string_literal: true

require "rails_helper"

RSpec.describe(EventIndexHandler, type: :concern) do
  it "must do the tings :)" do
    one = 1
    expect(one).to(eq(1))
  end
end

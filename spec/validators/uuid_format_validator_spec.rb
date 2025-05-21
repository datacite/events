# frozen_string_literal: true

require "active_support/testing/time_helpers"

RSpec.describe(UuidFormatValidator) do
  let(:valid_uuid) { "00000000-0000-0000-0000-000000000000" }
  let(:invalid_uuid) { "invalid-uuid" }

  it "is valid when the uuid is correct" do
    event = build(:event, uuid: valid_uuid)

    expect(event).to(be_valid)
  end

  it "is invalid when uuid is incorrect" do
    event = build(:event, uuid: invalid_uuid)

    expect(event).not_to(be_valid)
  end

  it "is invalid when uuid is incorrect and adds error message" do
    event = build(:event, uuid: invalid_uuid)
    event.validate

    expect(event.errors[:uuid]).to(include("invalid-uuid is not a valid UUID"))
  end
end

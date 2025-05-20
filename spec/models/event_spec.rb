# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Event, type: :model) do
  it "includes the RelationTypeHandler" do
    expect(described_class.ancestors).to(include(RelationTypeHandler))
  end

  it "includes the EventIndexHandler" do
    expect(described_class.ancestors).to(include(EventIndexHandler))
  end

  it "includes the EventFromSqsCreator" do
    expect(described_class.ancestors).to(include(EventFromSqsCreator))
  end

  it "includes the EventFromSqsUpdater" do
    expect(described_class.ancestors).to(include(EventFromSqsUpdater))
  end

  it "includes the Elasticsearch::Model" do
    expect(described_class.ancestors).to(include(Elasticsearch::Model))
  end
end

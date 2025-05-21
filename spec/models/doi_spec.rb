# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Doi, type: :model) do
  let(:valid_doi) { "10.0000/ZENODO.00000000" }
  let(:invalid_doi) { "invalid-doi" }

  describe "#publication_date" do
    it "returns nil when the doi is invalid" do
      expect(described_class.publication_date(invalid_doi)).to(be_nil)
    end

    it "returns nil when no doi is found" do
      allow(ActiveRecord::Base.connection).to(receive(:select_one).and_return(nil))

      expect(described_class.publication_date(valid_doi)).to(be_nil)
    end

    it "returns the publication date(just the year) when the doi is found" do
      allow(ActiveRecord::Base.connection).to(receive(:select_one).and_return(2025))

      expect(described_class.publication_date(valid_doi)).to(eq(2025))
    end
  end
end

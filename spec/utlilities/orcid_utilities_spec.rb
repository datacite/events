# frozen_string_literal: true

require "rails_helper"

RSpec.describe(OrcidUtilities) do
  describe "#orcid_from_url" do
    it "returns nil when url domain is invalid" do
      url = "https://invalid.org/0000-0000-0000-0000"
      orcid = described_class.orcid_from_url(url)

      expect(orcid).to(be_nil)
    end

    it "returns nil when url has missing protocol" do
      url = "invalid.org/0000-0000-0000-0000"
      orcid = described_class.orcid_from_url(url)

      expect(orcid).to(be_nil)
    end

    it "returns a non-nil orcid when passed a regular https orcid url" do
      url = "https://orcid.org/0000-0000-0000-0000"
      orcid = described_class.orcid_from_url(url)

      expect(orcid).to(eq("0000-0000-0000-0000"))
    end

    it "returns a non-nil orcid when passed a regular http orcid url" do
      url = "http://orcid.org/0000-0000-0000-0000"
      orcid = described_class.orcid_from_url(url)

      expect(orcid).to(eq("0000-0000-0000-0000"))
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe(DoiUtilities) do
  let(:bare_doi) { "10.5281/zenodo.1234567" }

  describe "#normalize_doi" do
    it "returns nil if the url is invalid" do
      url = "https://invalid.org/zenodo.invalid"
      doi = described_class.normalize_doi(url)

      expect(doi).to(be_nil)
    end

    it "returns a non-nil doi when passed a regular https doi url" do
      url = "https://doi.org/10.5281/zenodo.1234567"
      doi = described_class.normalize_doi(url)

      expect(doi).to(eq("https://doi.org/10.5281/zenodo.1234567"))
    end

    it "returns a non-nil doi when passed a regular http doi url" do
      url = "http://doi.org/10.5281/zenodo.1234567"
      doi = described_class.normalize_doi(url)

      expect(doi).to(eq("https://doi.org/10.5281/zenodo.1234567"))
    end

    it "returns a non-nil doi when passed a dx url" do
      url = "https://dx.doi.org/10.5281/zenodo.1234567"
      doi = described_class.normalize_doi(url)

      expect(doi).to(eq("https://doi.org/10.5281/zenodo.1234567"))
    end

    it "returns a non-nil doi when passed a handle test url" do
      url = "https://handle.test.datacite.org/10.5281/zenodo.1234567"
      doi = described_class.normalize_doi(url)

      expect(doi).to(eq("https://doi.org/10.5281/zenodo.1234567"))
    end

    it "returns a non-nil doi when passed a single slash url" do
      url = "https:/doi.org/10.5281/zenodo.1234567"
      doi = described_class.normalize_doi(url)

      expect(doi).to(eq("https://doi.org/10.5281/zenodo.1234567"))
    end

    it "returns a non-nil doi when passed a doi prefix url" do
      url = "doi:10.5281/zenodo.1234567"
      doi = described_class.normalize_doi(url)

      expect(doi).to(eq("https://doi.org/10.5281/zenodo.1234567"))
    end

    it "returns a non-nil doi when passed a bare doi" do
      url = "10.5281/zenodo.1234567"
      doi = described_class.normalize_doi(url)

      expect(doi).to(eq("https://doi.org/10.5281/zenodo.1234567"))
    end
  end

  describe "#uppercase_doi_from_url" do
    it "returns nil if url is invalid" do
      url = "https://invalid.org/zenodo.invalid"
      doi = described_class.uppercase_doi_from_url(url)

      expect(doi).to(be_nil)
    end

    it "returns a non-nil doi when passed a regular https doi url" do
      url = "https://doi.org/10.5281/zenodo.1234567"
      doi = described_class.uppercase_doi_from_url(url)

      expect(doi).to(eq("10.5281/ZENODO.1234567"))
    end

    it "returns a non-nil doi when passed a regular http doi url" do
      url = "http://doi.org/10.5281/zenodo.1234567"
      doi = described_class.uppercase_doi_from_url(url)

      expect(doi).to(eq("10.5281/ZENODO.1234567"))
    end

    it "returns a non-nil doi when passed a dx url" do
      url = "https://dx.doi.org/10.5281/zenodo.1234567"
      doi = described_class.uppercase_doi_from_url(url)

      expect(doi).to(eq("10.5281/ZENODO.1234567"))
    end

    it "returns a non-nil doi when passed a handle test url" do
      url = "https://handle.test.datacite.org/10.5281/zenodo.1234567"
      doi = described_class.uppercase_doi_from_url(url)

      expect(doi).to(eq("10.5281/ZENODO.1234567"))
    end

    it "returns a non-nil doi when passed a doi prefix url" do
      url = "doi:10.5281/zenodo.1234567"
      doi = described_class.uppercase_doi_from_url(url)

      expect(doi).to(eq("10.5281/ZENODO.1234567"))
    end

    it "returns a non-nil doi when passed a bare doi" do
      url = "10.5281/zenodo.1234567"
      doi = described_class.uppercase_doi_from_url(url)

      expect(doi).to(eq("10.5281/ZENODO.1234567"))
    end
  end

  describe "#doi_from_url" do
    it "returns nil if url is invalid" do
      url = "https://invalid.org/zenodo.invalid"
      doi = described_class.doi_from_url(url)

      expect(doi).to(be_nil)
    end

    it "returns a non-nil doi when passed a regular https doi url" do
      url = "https://doi.org/10.5281/zenodo.1234567"
      doi = described_class.doi_from_url(url)

      expect(doi).to(eq("10.5281/zenodo.1234567"))
    end

    it "returns a non-nil doi when passed a regular http doi url" do
      url = "http://doi.org/10.5281/zenodo.1234567"
      doi = described_class.doi_from_url(url)

      expect(doi).to(eq("10.5281/zenodo.1234567"))
    end

    it "returns a non-nil doi when passed a dx url" do
      url = "https://dx.doi.org/10.5281/zenodo.1234567"
      doi = described_class.doi_from_url(url)

      expect(doi).to(eq("10.5281/zenodo.1234567"))
    end

    it "returns a non-nil doi when passed a handle test url" do
      url = "https://handle.test.datacite.org/10.5281/zenodo.1234567"
      doi = described_class.doi_from_url(url)

      expect(doi).to(eq("10.5281/zenodo.1234567"))
    end

    it "returns a non-nil doi when passed a doi prefix url" do
      url = "doi:10.5281/zenodo.1234567"
      doi = described_class.doi_from_url(url)

      expect(doi).to(eq("10.5281/zenodo.1234567"))
    end

    it "returns a non-nil doi when passed a bare doi" do
      url = "10.5281/zenodo.1234567"
      doi = described_class.doi_from_url(url)

      expect(doi).to(eq("10.5281/zenodo.1234567"))
    end
  end
end

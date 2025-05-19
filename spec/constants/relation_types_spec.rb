# frozen_string_literal: true

require "rails_helper"

RSpec.describe(RelationTypes) do
  describe "Constants" do
    it "defines REFERENCE_RELATION_TYPES correctly" do
      expected = ["cites", "is-supplemented-by", "references"]

      expect(RelationTypes::REFERENCE_RELATION_TYPES).to(eq(expected))
    end

    it "defines CITATION_RELATION_TYPES correctly" do
      expected = ["is-cited-by", "is-supplement-to", "is-referenced-by"]

      expect(RelationTypes::CITATION_RELATION_TYPES).to(eq(expected))
    end

    it "defines INCLUDED_RELATION_TYPES as the union of REFERENCE_RELATION_TYPES and CITATION_RELATION_TYPES" do
      expected = RelationTypes::REFERENCE_RELATION_TYPES | RelationTypes::CITATION_RELATION_TYPES

      expect(RelationTypes::INCLUDED_RELATION_TYPES).to(eq(expected))
    end

    it "defines PART_RELATION_TYPES correctly" do
      expected = ["is-part-of", "has-part"]

      expect(RelationTypes::PART_RELATION_TYPES).to(eq(expected))
    end

    it "defines NEW_RELATION_TYPES correctly" do
      expected = ["is-reply-to", "is-translation-of", "is-published-in"]

      expect(RelationTypes::NEW_RELATION_TYPES).to(eq(expected))
    end

    it "defines RELATIONS_RELATION_TYPES correctly" do
      expected = [
        "compiles",
        "is-compiled-by",
        "documents",
        "is-documented-by",
        "has-metadata",
        "is-metadata-for",
        "is-derived-from",
        "is-source-of",
        "reviews",
        "is-reviewed-by",
        "requires",
        "is-required-by",
        "continues",
        "is-coutinued-by",
        "has-version",
        "is-version-of",
        "has-part",
        "is-part-of",
        "is-variant-from-of",
        "is-original-form-of",
        "is-identical-to",
        "obsoletes",
        "is-obsolete-by",
        "is-new-version-of",
        "is-previous-version-of",
        "describes",
        "is-described-by",
      ]

      expect(RelationTypes::RELATIONS_RELATION_TYPES).to(eq(expected))
    end

    it "defines ALL_RELATION_TYPES as the union of all relation types" do
      expected = (
        RelationTypes::RELATIONS_RELATION_TYPES |
        RelationTypes::NEW_RELATION_TYPES |
        RelationTypes::CITATION_RELATION_TYPES |
        RelationTypes::REFERENCE_RELATION_TYPES
      ).uniq

      expect(RelationTypes::ALL_RELATION_TYPES).to(match_array(expected))
    end

    it "defines OTHER_RELATION_TYPES correctly" do
      expected = (
        RelationTypes::RELATIONS_RELATION_TYPES | RelationTypes::NEW_RELATION_TYPES
      ) - RelationTypes::INCLUDED_RELATION_TYPES - RelationTypes::PART_RELATION_TYPES

      expect(RelationTypes::OTHER_RELATION_TYPES).to(match_array(expected))
    end

    it "defines RELATED_SOURCE_IDS correctly" do
      expected = ["datacite-related", "datacite-crossref", "crossref"]

      expect(RelationTypes::RELATED_SOURCE_IDS).to(eq(expected))
    end
  end
end

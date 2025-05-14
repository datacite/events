# frozen_string_literal: true

module RelationTypes
  REFERENCE_RELATION_TYPES = [
    "cites", "is-supplemented-by", "references",
  ].freeze

  # renamed to make it clearer that these relation types are grouped together as citations
  CITATION_RELATION_TYPES = [
    "is-cited-by",
    "is-supplement-to",
    "is-referenced-by",
  ].freeze

  INCLUDED_RELATION_TYPES = REFERENCE_RELATION_TYPES | CITATION_RELATION_TYPES

  PART_RELATION_TYPES = [
    "is-part-of",
    "has-part",
  ].freeze

  NEW_RELATION_TYPES = [
    "is-reply-to",
    "is-translation-of",
    "is-published-in",
  ].freeze

  RELATIONS_RELATION_TYPES = [
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
  ].freeze

  ALL_RELATION_TYPES = (
    RELATIONS_RELATION_TYPES |
    NEW_RELATION_TYPES |
    CITATION_RELATION_TYPES |
    REFERENCE_RELATION_TYPES
  ).uniq

  OTHER_RELATION_TYPES =
    (RELATIONS_RELATION_TYPES | NEW_RELATION_TYPES) -
    INCLUDED_RELATION_TYPES - PART_RELATION_TYPES

  RELATED_SOURCE_IDS = [
    "datacite-related",
    "datacite-crossref",
    "crossref",
  ].freeze
end

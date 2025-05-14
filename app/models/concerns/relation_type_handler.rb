# frozen_string_literal: true

# Handles setting the source and target doi data of an event when an event is created or updated.
# Method is only invoked via a before_validation callback in the events model.

module RelationTypeHandler
  include RelationTypes
  extend ActiveSupport::Concern

  def set_source_and_target_doi!
    return if subj_id.blank? || obj_id.blank?

    case relation_type_id
    when *REFERENCE_RELATION_TYPES
      self.source_doi = DoiUtilities.uppercase_doi_from_url(subj_id)
      self.target_doi = DoiUtilities.uppercase_doi_from_url(obj_id)
      self.source_relation_type_id = "references"
      self.target_relation_type_id = "citations"
    when *CITATION_RELATION_TYPES
      self.source_doi = DoiUtilities.uppercase_doi_from_url(obj_id)
      self.target_doi = DoiUtilities.uppercase_doi_from_url(subj_id)
      self.source_relation_type_id = "references"
      self.target_relation_type_id = "citations"
    when "unique-dataset-investigations-regular"
      self.target_doi = DoiUtilities.uppercase_doi_from_url(obj_id)
      self.target_relation_type_id = "views"
    when "unique-dataset-requests-regular"
      self.target_doi = DoiUtilities.uppercase_doi_from_url(obj_id)
      self.target_relation_type_id = "downloads"
    when "has-version"
      self.source_doi = DoiUtilities.uppercase_doi_from_url(subj_id)
      self.target_doi = DoiUtilities.uppercase_doi_from_url(obj_id)
      self.source_relation_type_id = "versions"
      self.target_relation_type_id = "version_of"
    when "is-version-of"
      self.source_doi = DoiUtilities.uppercase_doi_from_url(obj_id)
      self.target_doi = DoiUtilities.uppercase_doi_from_url(subj_id)
      self.source_relation_type_id = "versions"
      self.target_relation_type_id = "version_of"
    when "has-part"
      self.source_doi = DoiUtilities.uppercase_doi_from_url(subj_id)
      self.target_doi = DoiUtilities.uppercase_doi_from_url(obj_id)
      self.source_relation_type_id = "parts"
      self.target_relation_type_id = "part_of"
    when "is-part-of"
      self.source_doi = DoiUtilities.uppercase_doi_from_url(obj_id)
      self.target_doi = DoiUtilities.uppercase_doi_from_url(subj_id)
      self.source_relation_type_id = "parts"
      self.target_relation_type_id = "part_of"
    end
  end
end

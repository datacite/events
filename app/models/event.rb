# frozen_string_literal: true

class Event < ApplicationRecord
  # Included Modules
  include Events::RelationTypeHandler
  include Events::EventIndexHandler
  include Events::EventFromSqsUpdater
  include Elasticsearch::Model

  # Extended Modules
  extend Events::EventFromSqsCreator

  # Attributes
  attribute :uuid, :text
  attribute :subj_id, :text
  attribute :obj_id, :text
  attribute :aasm_state, :string, default: "waiting"
  attribute :state_event, :string
  attribute :callback, :text
  attribute :error_messages, :text
  attribute :source_token, :text
  attribute :indexed_at, :datetime, default: -> { Time.zone.at(0) }
  attribute :occurred_at, :datetime
  attribute :message_action, :string, default: "create"
  attribute :subj, :text
  attribute :obj, :text
  attribute :total, :integer, default: 1
  attribute :license, :string
  attribute :source_doi, :text
  attribute :target_doi, :text
  attribute :source_relation_type_id, :string
  attribute :target_relation_type_id, :string
  attribute :relation_type_id, :string
  attribute :source_id, :string
  attribute :indexed_at, :datetime, default: "1970-01-01 00:00:00"
  attribute :updated_at, :datetime
  attribute :created_at, :datetime

  # Validations
  validates :uuid, presence: true, uuid_format: true, uniqueness: { case_sensitive: false, length: { maximum: 36 } }
  validates :subj_id, presence: true
  validates :obj_id, presence: true
  validates :source_id, presence: true
  validates :source_token, presence: true
  validates :message_action, presence: true, length: { maximum: 191 }
  validates :indexed_at, presence: true

  # Getters
  def subj_hash
    return {} if subj.blank?

    JSON.parse(subj)
  rescue => e
    Rails.logger.error("JSON parsing failed for event.subj: #{e.message}")
    {}
  end

  def obj_hash
    return {} if obj.blank?

    JSON.parse(obj)
  rescue => e
    Rails.logger.error("JSON parsing failed for event.obj: #{e.message}")
    {}
  end

  # Callback Hooks

  # We run some special logic in order to set the source and target doi
  # and their related relation type ids.
  before_validation :set_source_and_target_doi!

  # After the event is persisted successfully to the database, we index the event in OpenSearch.
  after_commit -> { EventIndexJob.perform_later(self) }

  # OpenSearch Mappings
  mapping dynamic: "false" do
    indexes :uuid, type: :keyword
    indexes :subj_id, type: :keyword
    indexes :obj_id, type: :keyword
    indexes :doi, type: :keyword
    indexes :orcid, type: :keyword
    indexes :prefix, type: :keyword
    indexes :subtype, type: :keyword
    indexes :citation_type, type: :keyword
    indexes :issn, type: :keyword
    indexes :subj,
      type: :object,
      properties: {
        type: { type: :keyword },
        id: { type: :keyword },
        uid: { type: :keyword },
        proxyIdentifiers: { type: :keyword },
        datePublished: {
          type: :date,
          format: "date_optional_time||yyyy-MM-dd||yyyy-MM||yyyy",
          ignore_malformed: true,
        },
        registrantId: { type: :keyword },
        cache_key: { type: :keyword },
      }
    indexes :obj,
      type: :object,
      properties: {
        type: { type: :keyword },
        id: { type: :keyword },
        uid: { type: :keyword },
        proxyIdentifiers: { type: :keyword },
        datePublished: {
          type: :date,
          format: "date_optional_time||yyyy-MM-dd||yyyy-MM||yyyy",
          ignore_malformed: true,
        },
        registrantId: { type: :keyword },
        cache_key: { type: :keyword },
      }
    indexes :source_doi, type: :keyword
    indexes :target_doi, type: :keyword
    indexes :source_relation_type_id, type: :keyword
    indexes :target_relation_type_id, type: :keyword
    indexes :source_id, type: :keyword
    indexes :source_token, type: :keyword
    indexes :message_action, type: :keyword
    indexes :relation_type_id, type: :keyword
    indexes :registrant_id, type: :keyword
    indexes :access_method, type: :keyword
    indexes :metric_type, type: :keyword
    indexes :total, type: :integer
    indexes :license, type: :text, fields: { keyword: { type: "keyword" } }
    indexes :error_messages, type: :object
    indexes :callback, type: :text
    indexes :aasm_state, type: :keyword
    indexes :state_event, type: :keyword
    indexes :year_month, type: :keyword
    indexes :created_at, type: :date
    indexes :updated_at, type: :date
    indexes :indexed_at, type: :date
    indexes :occurred_at, type: :date
    indexes :citation_id, type: :keyword
    indexes :citation_year, type: :integer
    indexes :cache_key, type: :keyword
  end
end

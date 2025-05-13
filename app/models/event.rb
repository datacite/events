# frozen_string_literal: true

class Event < ApplicationRecord
  include RelationTypeHandler
  # include Modelable
  # include Identifiable
  # include Elasticsearch::Model

  # Attributes
  attribute :uuid, :text
  attribute :subj_id, :text
  attribute :obj_id, :text
  attribute :aasm_state, :string
  attribute :state_event, :string
  attribute :callback, :text
  attribute :error_messages, :text
  attribute :source_token, :text
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
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

  # Validations
  validates :uuid, presence: true, uuid_format: true, uniqueness: { case_sensitive: false, length: { maximum: 36 } }
  validates :subj_id, presence: true
  validates :obj_id, presence: true
  validates :source_id, presence: true
  validates :source_token, presence: true
  validates :message_action, presence: true, length: { maximum: 191 }
  validates :created_at, presence: true
  validates :updated_at, presence: true
  validates :indexed_at, presence: true

  # Callbacks
  before_validation :set_source_and_target_doi!
end

# frozen_string_literal: true

class Event < ApplicationRecord
  # include Modelable
  # include Identifiable
  # include Elasticsearch::Model

  # Attributes
  attribute :uuid, :text
  attribute :subj_id, :text
  attribute :obj_id, :text
  attribute :source_id, :string
  attribute :aasm_state, :string # could we remove this
  attribute :state_event, :string # could we remove this
  attribute :callback, :text
  attribute :error_messages, :text
  attribute :source_token, :text
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
  attribute :indexed_at, :datetime, default: -> { Time.zone.at(0) }
  attribute :occurred_at, :datetime
  attribute :message_action, :string, default: "create" # how is this set?
  attribute :subj, :text
  attribute :obj, :text
  attribute :total, :integer, default: 1
  attribute :license, :string
  attribute :source_doi, :text
  attribute :target_doi, :text
  attribute :source_relation_type_id, :string
  attribute :target_relation_type_id, :string

  # Validations
  validates :uuid, presence: true, uniqueness: {
    case_sensitive: false,
    length: { maximum: 36 },
  }
  validates :subj_id, presence: true
  validates :message_action, presence: true, length: { maximum: 191 }
  validates :created_at, presence: true
  validates :updated_at, presence: true
  validates :indexed_at, presence: true
end

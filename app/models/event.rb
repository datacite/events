# frozen_string_literal: true

class Event
  include ActiveModel::Model
  include ActiveModel::Attributes
  # include Modelable
  # include Identifiable
  # include Elasticsearch::Model

  attribute :id, :integer
  attribute :uuid, :string
  attribute :subj_id, :string
  attribute :obj_id, :string
  attribute :source_id, :string
  attribute :aasm_state, :string # could we remove this
  attribute :state_event, :string # could we remove this
  attribute :callback, :string
  attribute :error_messages, :string
  attribute :source_token, :string
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
  attribute :indexed_at, :datetime
  attribute :occurred_at, :datetime
  attribute :message_action, :string # how is this set?
  attribute :subj, :string
  attribute :obj, :string
  attribute :total, :integer
  attribute :license, :string
  attribute :source_doi, :string
  attribute :target_doi, :string
  attribute :source_relation_type_id, :string
  attribute :target_relation_type_id, :string
end

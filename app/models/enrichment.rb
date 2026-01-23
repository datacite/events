# frozen_string_literal: true

class PocRecord < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :enrichments }
end

class Enrichment < PocRecord
  serialize :enriched_value, coder: JSON
  serialize :original_value, coder: JSON
end

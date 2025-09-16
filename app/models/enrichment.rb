# frozen_string_literal: true

class Enrichment < ApplicationRecord
  connects_to database: { writing: :enrichments }
end

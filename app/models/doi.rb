# frozen_string_literal: true

class Doi < ApplicationRecord
  # Map the doi model to the dataset table in the datacite mysql database
  self.table_name = "dataset"

  # Attributes
  attribute :doi, :string
  attribute :publication_year, :integer
end

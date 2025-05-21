# frozen_string_literal: true

class Doi
  class << self
    def publication_date(doi)
      search_doi = DoiUtilities.uppercase_doi_from_url(doi)

      return nil if search_doi.blank?

      sql = "SELECT publication_year FROM dataset WHERE doi = :doi LIMIT 1"
      sanitized_sql = ActiveRecord::Base.send(:sanitize_sql_array, [sql, { doi: search_doi }])

      ActiveRecord::Base.connection.select_one(sanitized_sql)
    end
  end
end

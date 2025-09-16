# frozen_string_literal: true

namespace :enrichment do
  desc "Create the enrichments sqlite database table"
  task create_sqlite_table: :environment do
    ActiveRecord::Base.establish_connection(:enrichments)
    ActiveRecord::Base.connection.execute(<<-SQL)
      CREATE TABLE IF NOT EXISTS enrichments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        doi TEXT,
        source TEXT,
        process TEXT,
        field TEXT,
        action TEXT,
        originalValue TEXT,
        enrichedValue TEXT,
        created DATETIME,
        updated DATETIME,
        produced DATETIME
      );
    SQL
  end
end

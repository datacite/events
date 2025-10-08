# frozen_string_literal: true

require "csv"
require "json"

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
        original_value TEXT,
        enriched_value TEXT,
        created DATETIME,
        updated DATETIME,
        produced DATETIME
      );
    SQL
  end

  desc "Ingest ARXIV data"
  task ingest_arxiv: :environment do
    CSV.foreach("lib/data/20250426_arxiv_sample_3_matches.csv", headers: true) do |row|
      enrichment = Enrichment.new(
        doi:  row["input_doi"],
        source: "COMET",
        process: "10.000/FAKE.PROCESS",
        field: "types",
        action: "update",
        enriched_value: {
          ris: "GEN",
          bibtex: "misc",
          citeproc: "article",
          schemaOrg: "CreativeWork",
          resourceType: "Article",
          resourceTypeGeneral: "Dataset",
        },
        created: Time.current.utc,
        updated: Time.current.utc,
        produced: Time.current.utc - 5.days,
      )

      if enrichment.save
        puts("Created enrichment for #{row["input_doi"]}")
      else
        puts("Failed to create enrichment for #{row["input_doi"]}")
        puts(enrichment.errors.full_messages.join(","))
      end
    end
  end

  desc "Ingest procedural resource type"
  task ingest_procedural_resource_type: :environment do
    file = File.read("lib/data/datacite_procedural_resource_type_general_reclassifications_datacite_lookup_format.json")
    data = JSON.parse(file)
    count = 0

    data.each do |item|
      count += 1

      break if count == 1001

      enrichment = Enrichment.new(
        doi:  item["doi"],
        source: "COMET",
        process: "10.000/FAKE.PROCESS",
        field: "types",
        action: "update",
        enriched_value: item["currentTypes"],
        created: Time.current.utc,
        updated: Time.current.utc,
        produced: Time.current.utc - 5.days,
      )

      if enrichment.save
        puts("Created enrichment for #{item["doi"]}")
      else
        puts("Failed to create enrichment for #{item["doi"]}")
        puts(enrichment.errors.full_messages.join(","))
      end
    end
  end
end

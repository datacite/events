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
    csv_path = Rails.root.join("lib/data/arxiv_preprint_matching.csv")
    count = 0

    CSV.foreach(csv_path, headers: true) do |row|
      count += 1

      break if count == 2001

      item = row.to_hash

      enrichment = Enrichment.new(
        doi:  item["doi"],
        source: item["source"],
        process: item["process"],
        field: item["field"],
        action: item["action"],
        original_value: item["originalValue"],
        enriched_value: JSON.parse(item["enrichedValue"]),
        created: Time.current.utc,
        updated: Time.current.utc,
        produced: item["produced"],
      )

      if enrichment.save
        puts("Created enrichment for #{item["doi"]}")
      else
        puts("Failed to create enrichment for #{item["doi"]}")
        puts(enrichment.errors.full_messages.join(","))
      end
    end
  end

  # desc "Ingest ARXIV data"
  # task ingest_arxiv: :environment do
  #   file = File.read("lib/data/20250615_arxiv_preprint_matching_results.json")
  #   data = JSON.parse(file)
  #   count = 0

  #   data.each do |item|
  #     count += 1

  #     break if count == 2001

  #     enrichment = Enrichment.new(
  #       doi:  item["input_doi"],
  #       source: "COMET",
  #       process: "10.0000/FAKE.PROCESS",
  #       field: "relatedIdentifiers",
  #       action: "insert",
  #       original_value: nil,
  #       enriched_value: {
  #         relationType: "Preprint",
  #         relatedIdentifier: item["matched_doi"],
  #         relatedIdentifierType: "DOI",
  #       },
  #       created: Time.current.utc,
  #       updated: Time.current.utc,
  #       produced: Time.current.utc - 5.days,
  #     )

  #     if enrichment.save
  #       puts("Created enrichment for #{item["input_doi"]}")
  #     else
  #       puts("Failed to create enrichment for #{item["input_doi"]}")
  #       puts(enrichment.errors.full_messages.join(","))
  #     end
  #   end
  # end

  desc "Ingest procedural resource type"
  task ingest_procedural_resource_type: :environment do
    file = File.read("lib/data/datacite_procedural_resource_type_general_reclassifications_datacite_lookup_format.json")
    data = JSON.parse(file)
    count = 0

    data.each do |item|
      count += 1

      break if count == 2001

      enrichment = Enrichment.new(
        doi:  item["doi"],
        source: "COMET",
        process: "10.0000/FAKE.PROCESS",
        field: "types",
        action: "update",
        original_value: item["currentTypes"],
        enriched_value: item["reclassifiedTypes"],
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

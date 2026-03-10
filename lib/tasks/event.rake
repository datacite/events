namespace :event do
  desc "Import Crossref DOIs for events created within a date range"
  # example command: IMPORT_DATE=2025-06-11 bundle exec rake event:import_crossref_event_dois
  task import_crossref_event_dois: :environment do
    date = Date.parse(ENV["IMPORT_DATE"])
    start_date = date.beginning_of_day
    end_date = (date + 1).beginning_of_day

    puts("Import date: #{date}")
    puts("Start date: #{start_date}")
    puts("End date: #{end_date}")

    events = Event
      .where(source_id: ["crossref", "datacite-crossref"])
      .where(created_at: start_date...end_date)
      .order(:id)

    puts("Number of events: #{events.count}")

    batch_count = 0

    events.in_batches(of: 10_000) do |batch|
      batch_count += 1
      puts("Processing batch: #{batch_count}")
      batch_events = batch.select(:id, :subj_id, :obj_id).to_a

      Parallel.each(batch_events, in_threads: 20) do |batch_event|
        SqsUtilities.send_events_other_doi_job_message({
          subj_id: batch_event.subj_id,
          obj_id: batch_event.obj_id,
        })
      end
    end

    puts("Rake task has completed!")
  end

  desc "Re-queue SQS re-index messages for unique DOIs in events updated within a date range"
  # Dates are inclusive. END_DATE defaults to START_DATE for single-day runs.
  task reindex_touched_dois: :environment do
    raise "START_DATE is required" if ENV["START_DATE"].blank?

    start_date = Date.parse(ENV["START_DATE"])
    end_date   = Date.parse(ENV["END_DATE"].presence || ENV["START_DATE"])

    raise "END_DATE must be on or after START_DATE" if end_date < start_date

    count = Event.reindex_touched_dois(
      start_date: start_date,
      end_date:   end_date,
    )

    puts "Sent #{count} unique DOIs for re-indexing."
  end
end

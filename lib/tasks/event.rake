# frozen_string_literal: true

require "active_support/all"

namespace :event do
  desc "Import Crossref DOIs for events created within a date range"
  # example command: IMPORT_DATE=2025-06-11 bundle exec rake event:import_crossref_event_dois
  task import_crossref_event_dois: :environment do
    date = Date.parse(ENV["IMPORT_DATE"])
    start_date = date.beginning_of_day
    end_date = (date + 1.month).beginning_of_month.beginning_of_day

    puts("Import date: #{date}")
    puts("Start date: #{start_date}")
    puts("End date: #{end_date}")

    events = Event
      .where(source_id: ["crossref", "datacite-crossref"])
      .where(created_at: start_date...end_date)

    puts("Number of events: #{events.count}")
    puts("Enqueueing messages to events_other_doi_job...")

    Parallel.each(events, in_threads: 20) do |event|
      SqsUtilities.send_events_other_doi_job_message({
        subj_id: event.subj_id,
        obj_id: event.obj_id,
      })
    end

    puts("Task complete!")
  end
end

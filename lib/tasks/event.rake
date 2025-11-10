# frozen_string_literal: true

namespace :event do
  desc "Import Crossref DOIs for events created within a date range"
  task import_crossref_event_dois: :environment do
    date = Date.parse(ENV["IMPORT_DATE"])
    start_date = date.beginning_of_day
    end_date = (date + 1).beginning_of_day

    puts("Imported date: #{date}")
    puts("Start date: #{start_date}")
    puts("End date: #{end_date}")

    events = Event
      .where(source_id: ["crossref", "datacite-crossref"])
      .where(created_at: start_date...end_date)

    puts("Number of events: #{events.count}")

    events.each do |event|
      payload = {
        subj_id: event.subj_id,
        obj_id: event.obj_id,
        source_id: event.source_id,
      }

      puts("SQS message payload: #{payload.inspect}")

      # SqsUtilities.send_events_other_doi_job_message({
      #   subj_id: event.subj_id,
      #   obj_id: event.obj_id,
      # })
    end
  end
end

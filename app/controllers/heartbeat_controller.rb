# frozen_string_literal: true

class HeartbeatController < ApplicationController
  def index
    SqsUtilities.send_events_other_doi_job_message({ subj_id: "10.13038/FOO.BAR", obj_id: "10.13038/BAR.FOO" })
    render(
      plain: "OK",
      status: :ok,
      content_type: "text/plain",
    )
  end
end

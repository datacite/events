# frozen_string_literal: true

class HeartbeatController < ApplicationController
  def index
    SqsUtilities.send_events_other_doi_job_message({ subj_id: "fake_subj_id", obj_id: "fake_obj_id" })
    render(
      plain: "OK",
      status: :ok,
      content_type: "text/plain",
    )
  end
end

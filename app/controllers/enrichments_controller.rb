# frozen_string_literal: true

class EnrichmentsController < ApplicationController
  def doi
    render(json: { message: params[:doi] })
  end

  def dois
    render(json: { message: "list result" })
  end
end

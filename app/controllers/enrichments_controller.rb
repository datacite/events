# frozen_string_literal: true

# sample ingestion file = 20250426_arxiv_sample_3_matches

class EnrichmentsController < ApplicationController
  def doi
    doi = fetch_doi(params[:doi])

    if doi.blank?
      render(json: { error: "doi not found" }, status: :not_found)
      return
    end

    enrichments = Enrichment.where(doi: params[:doi])

    if enrichments.empty?
      render(json: { error: "no enrichments found for #{params[:doi]}" }, status: :not_found)
      return
    end

    enrichments.each do |enrichment|
      action_strategy_pattern(enrichment, doi)
      build_enrichments_field(enrichment, doi)
    end

    render(json: doi)
  end

  def dois
    page_size = 5
    page = params[:page]&.to_i || 0
    dois = Enrichment.order(:doi).distinct.offset(page_size * (page - 1)).limit(page_size).pluck(:doi)
    enriched_dois = []
    Rails.logger.info("########dois")
    Rails.logger.info(dois)

    dois.each do |doi|
      enrichments = Enrichment.where(doi: doi)
      enriched_doi = fetch_doi(doi)

      next if enriched_doi.blank?

      enrichments.each do |enrichment|
        action_strategy_pattern(enrichment, enriched_doi)
        build_enrichments_field(enrichment, enriched_doi)
        enriched_dois << enriched_doi
      end
    end

    render(json: enriched_dois)
  end

  private

  def fetch_doi(doi)
    response = Faraday.get("https://api.datacite.org/dois/#{doi}?detail=true&publisher=true&affiliation=true")
    JSON.parse(response.body).dig("data", "attributes") if response.success?
  end

  def action_strategy_pattern(enrichment, doi)
    action = enrichment["action"]
    case action
    when "insert"
      doi[enrichment["field"]] ||= []
      doi[enrichment["field"]] << enrichment["enriched_value"]
    when "update"
      doi[enrichment["field"]] = enrichment["enriched_value"]
    when "update_child"
      field = enrichment["field"]
      doi[field].each_with_index do |item, index|
        if item == enrichment["original_value"]
          doi[field][index] = enrichment["enriched_value"]
        end
      end
    when "delete_child"
      field = enrichment["field"]
      doi[field] ||= []
      doi[field].each_with_index do |item, index|
        if item == enrichment["original_value"]
          doi[field].delete_at(index)
          break
        end
      end
    end
  end

  def build_enrichments_field(enrichment, doi)
    doi["relationships"] ||= {}
    doi["relationships"]["enrichments"] ||= []
    doi["relationships"]["enrichments"] << [enrichment]
  end
end

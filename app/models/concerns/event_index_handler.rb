# frozen_string_literal: true

module EventIndexHandler
  include RelationTypes
  extend ActiveSupport::Concern

  # Used to prepare the event record for indexing
  def as_indexed_json(_options = {})
    {
      "uuid" => uuid,
      "subj_id" => subj_id,
      "obj_id" => obj_id,
      "subj" => subj.merge(cache_key: subj_cache_key),
      "obj" => obj.merge(cache_key: obj_cache_key),
      "source_doi" => source_doi,
      "target_doi" => target_doi,
      "source_relation_type_id" => source_relation_type_id,
      "target_relation_type_id" => target_relation_type_id,
      "doi" => doi,
      "orcid" => orcid,
      "issn" => issn,
      "prefix" => prefix,
      "subtype" => subtype,
      "citation_type" => citation_type,
      "source_id" => source_id,
      "source_token" => source_token,
      "message_action" => message_action,
      "relation_type_id" => relation_type_id,
      "registrant_id" => registrant_id,
      "access_method" => access_method,
      "metric_type" => metric_type,
      "total" => total,
      "license" => license,
      "error_messages" => error_messages,
      "aasm_state" => aasm_state,
      "state_event" => state_event,
      "year_month" => year_month,
      "created_at" => created_at,
      "updated_at" => updated_at,
      "indexed_at" => indexed_at,
      "occurred_at" => occurred_at,
      "citation_id" => citation_id,
      "citation_year" => citation_year,
      "cache_key" => cache_key,
    }
  end

  def subj_cache_key
    timestamp = subj["dateModified"] || Time.zone.now.iso8601
    "objects/#{subj_id}-#{timestamp}"
  end

  def obj_cache_key
    timestamp = obj["dateModified"] || Time.zone.now.iso8601
    "objects/#{obj_id}-#{timestamp}"
  end

  def doi
    Array.wrap(subj["proxyIdentifiers"]).grep(%r{\A10\.\d{4,5}/.+\z}) { ::Regexp.last_match(1) } +
      Array.wrap(obj["proxyIdentifiers"]).grep(%r{\A10\.\d{4,5}/.+\z}) { ::Regexp.last_match(1) } +
      Array.wrap(subj["funder"]).map { |f| doi_from_url(f["@id"]) }.compact +
      Array.wrap(obj["funder"]).map { |f| doi_from_url(f["@id"]) }.compact +
      [doi_from_url(subj_id), doi_from_url(obj_id)].compact
  end

  def orcid
    Array.wrap(subj["author"]).map { |f| orcid_from_url(f["@id"]) }.compact +
      Array.wrap(obj["author"]).map { |f| orcid_from_url(f["@id"]) }.compact +
      [orcid_from_url(subj_id), orcid_from_url(obj_id)].compact
  end

  def issn
    Array.wrap(subj.dig("periodical", "issn")).compact +
      Array.wrap(obj.dig("periodical", "issn")).compact
  rescue TypeError
    nil
  end

  def prefix
    [doi.map { |d| d.to_s.split("/", 2).first }].compact
  end

  def subtype
    [subj["@type"], obj["@type"]].compact
  end

  def citation_type
    if subj["@type"].blank? || subj["@type"] == "CreativeWork" ||
        obj["@type"].blank? ||
        obj["@type"] == "CreativeWork"
      return
    end

    [subj["@type"], obj["@type"]].compact.sort.join("-")
  end

  def registrant_id
    [
      subj["registrantId"],
      obj["registrantId"],
      subj["providerId"],
      obj["providerId"],
    ].compact
  end

  def access_method
    if /(requests|investigations)/.match?(relation_type_id.to_s)
      relation_type_id.split("-").last if relation_type_id.present?
    end
  end

  def metric_type
    if /(requests|investigations)/.match?(relation_type_id.to_s)
      arr = relation_type_id.split("-", 4)
      arr[0..2].join("-")
    end
  end

  def year_month
    occurred_at.utc.iso8601[0..6] if occurred_at.present?
  end

  def citation_id
    [subj_id, obj_id].sort.join("-")
  end

  def citation_year
    if (INCLUDED_RELATION_TYPES + RELATIONS_RELATION_TYPES).exclude?(relation_type_id)
      return ""
    end

    subj_publication = subj["datePublished"] ||
      subj["date_published"] ||
      (date_published(subj_id) || year_month)

    obj_publication = obj["datePublished"] ||
      obj["date_published"] ||
      (date_published(obj_id) || year_month)

    [subj_publication[0..3].to_i, obj_publication[0..3].to_i].max
  end

  def cache_key
    timestamp = updated_at || Time.zone.now
    "events/#{uuid}-#{timestamp.iso8601}"
  end
end

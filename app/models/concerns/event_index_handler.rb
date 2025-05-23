# frozen_string_literal: true

module EventIndexHandler
  extend ActiveSupport::Concern

  # Used to prepare the event record for indexing.
  # Invoked implicitely when document indexing occurs.
  def as_indexed_json(_options = {})
    {
      "uuid" => uuid,
      "subj_id" => subj_id,
      "obj_id" => obj_id,
      "subj" => subj_hash.merge(cache_key: subj_cache_key),
      "obj" => obj_hash.merge(cache_key: obj_cache_key),
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
    timestamp = subj_hash["dateModified"] || Time.zone.now.iso8601
    "objects/#{subj_id}-#{timestamp}"
  end

  def obj_cache_key
    timestamp = obj_hash["dateModified"] || Time.zone.now.iso8601
    "objects/#{obj_id}-#{timestamp}"
  end

  # QUESTION -> SHOULD THIS ALLOW DUPLICATE VALUES???
  def doi
    subj_proxy_identifier_dois + obj_proxy_identifier_dois + subj_funder_dois + obj_funder_dois +
      [DoiUtilities.doi_from_url(subj_id), DoiUtilities.doi_from_url(obj_id)].compact
  end

  def orcid
    Array.wrap(subj_hash["author"]).map { |f| OrcidUtilities.orcid_from_url(f["@id"]) }.compact +
      Array.wrap(obj_hash["author"]).map { |f| OrcidUtilities.orcid_from_url(f["@id"]) }.compact +
      [OrcidUtilities.orcid_from_url(subj_id), OrcidUtilities.orcid_from_url(obj_id)].compact
  end

  def issn
    Array.wrap(subj_hash.dig("periodical", "issn")).compact +
      Array.wrap(obj_hash.dig("periodical", "issn")).compact
  rescue TypeError
    nil
  end

  def prefix
    [doi.map { |d| d.to_s.split("/", 2).first }].compact
  end

  def subtype
    [subj_hash["@type"], obj["@type"]].compact
  end

  def citation_type
    if subj_hash["@type"].blank? || subj_hash["@type"] == "CreativeWork" ||
        obj_hash["@type"].blank? ||
        obj_hash["@type"] == "CreativeWork"
      return
    end

    [subj_hash["@type"], obj_hash["@type"]].compact.sort.join("-")
  end

  def registrant_id
    [
      subj_hash["registrantId"],
      obj_hash["registrantId"],
      subj_hash["providerId"],
      obj_hash["providerId"],
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
    if (RelationTypes::INCLUDED_RELATION_TYPES + RelationTypes::RELATIONS_RELATION_TYPES).exclude?(relation_type_id)
      return ""
    end

    subj_publication = subj_hash["datePublished"] ||
      subj_hash["date_published"] ||
      (date_published(subj_id) || year_month)

    obj_publication = obj_hash["datePublished"] ||
      obj_hash["date_published"] ||
      (date_published(obj_id) || year_month)

    [subj_publication[0..3].to_i, obj_publication[0..3].to_i].max
  end

  def cache_key
    timestamp = updated_at || Time.zone.now

    "events/#{uuid}-#{timestamp.iso8601}"
  end

  def date_published(doi)
    Doi.publication_date(doi)
  end

  private

  def subj_proxy_identifier_dois
    # Extract all subj proxy identifiers that match 10.()dot followed by 4 or 5 digits
    # then followed by a slash and finally followed by at least 1 character.
    # i.e. 10.1234/a, 10.12345/zenodo.100
    Array.wrap(subj_hash["proxyIdentifiers"])
      .map { |s| s[%r{\A(10\.\d{4,5}/.+)\z}, 1] }
      .compact
  end

  def obj_proxy_identifier_dois
    # Extract all obj proxy identifiers that match 10.()dot followed by 4 or 5 digits
    # then followed by a slash and finally followed by at least 1 character.
    # i.e. 10.1234/a, 10.12345/zenodo.100
    Array.wrap(obj_hash["proxyIdentifiers"])
      .map { |s| s[%r{\A(10\.\d{4,5}/.+)\z}, 1] }
      .compact
  end

  def subj_funder_dois
    Array.wrap(subj_hash["funder"])
      .map { |f| DoiUtilities.doi_from_url(f["@id"]) }
      .compact
  end

  def obj_funder_dois
    Array.wrap(obj_hash["funder"])
      .map { |f| DoiUtilities.doi_from_url(f["@id"]) }
      .compact
  end
end

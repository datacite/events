# frozen_string_literal: true

FactoryBot.define do
  factory :event_sqs_message, class: Struct.new(
    :message_action,
    :total,
    :uuid,
    :source_token,
    :subj_id,
    :obj_id,
    :relation_type_id,
    :source_id,
    :occurred_at,
    :timestamp,
    :license,
    :subj,
    :obj,
  ) do
    messageAction { "create" }
    total { 100 }
    uuid { "00000000-0000-0000-0000-000000000000" }
    sourceToken { "00000000-0000-0000-0000-000000000001" }
    subjId { "00000000-0000-0000-0000-000000000002" }
    objId { "00000000-0000-0000-0000-000000000003" }
    relationTypeId { "references" }
    sourceId { "orcid-affiliation" }
    occurredAt { "2025-01-01T00:00:00.000Z" }
    timestamp { "2025-01-01T00:00:00.001Z" }
    license { "https://creativecommons.org/publicdomain/zero/1.0/" }
    subj do
      {
        "@id": "https://doi.org/10.5281/zenodo.00000001",
        "@type": "Organization",
        "name": "DataCite",
        "location": {
          "type": "postalAddress",
          "addressCountry": "Germany",
        },
      }
    end
    obj do
      {
        "@id": "https://doi.org/10.5281/zenodo.00000002",
        "@type": "Organization",
        "name": "DataCite",
        "location": {
          "type": "postalAddress",
          "addressCountry": "Germany",
        },
      }
    end

    initialize_with { attributes.stringify_keys }
  end
end

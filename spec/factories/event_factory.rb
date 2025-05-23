# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    uuid { "00000000-0000-0000-0000-000000000000" }
    subj_id { "10.0000/subj.id" }
    obj_id { "10.0000/obj.id" }
    source_id { "orcid-affiliation" }
    source_token { "00000000-0000-0000-0000-000000000001" }
    message_action { "create" }
    indexed_at { "2025-01-01 00:00:00" }
  end
end

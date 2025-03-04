# frozen_string_literal: true

class Event < ApplicationRecord
  include Modelable
  include Identifiable
  include Elasticsearch::Model
end

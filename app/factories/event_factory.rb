# frozen_string_literal: true

module Factories
  class EventFactory
    class << self
      def create_instance(values)
        event = Event.new
        event.attributes = ...values
        event
      end
    end
  end
end

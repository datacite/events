# frozen_string_literal: true

class UuidFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless UUID.validate(value)
      record.errors.add(attribute, "#{value} is not a valid UUID")
    end
  end
end

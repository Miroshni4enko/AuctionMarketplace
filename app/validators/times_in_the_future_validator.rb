# frozen_string_literal: true

class TimesInTheFutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value && value < DateTime.current
      record.errors[attribute] << (options[:message] || "can't be in the past")
    end
  end
end

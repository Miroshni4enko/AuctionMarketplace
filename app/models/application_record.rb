# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def created_status_validation
    if status != "pending"
      errors.add(:status, "must be pending")
    end
  end

  def status_changed_to? (changed_status)
    saved_change_to_status? && status == changed_status
  end
end

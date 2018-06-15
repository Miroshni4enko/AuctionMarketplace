# frozen_string_literal: true

module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_by_criteria_and_user_id(criteria, user_id)
      results = self.where(nil)
      results.public_send(criteria + "_by_user_id", user_id)
    end
  end
end

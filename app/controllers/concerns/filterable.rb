# frozen_string_literal: true

module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_by_criteria(criteria)
      results = self.where(nil)
      results.public_send(criteria + "_criteria")
    end
  end
end

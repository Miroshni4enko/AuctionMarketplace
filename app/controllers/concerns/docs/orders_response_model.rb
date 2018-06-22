# frozen_string_literal: true

module Docs
  module OrdersResponseModel
    extend ActiveSupport::Concern
    included do
      swagger_model :Order do
        property :id, :integer, :required, "ID of Order"
        property :arrival_type, :string, :required, "Arrival type"
        property_list :status, :string, :required, "Status", ["pending", "sent", "delivered"]
        property :arrival_location, :string, :required, "Arrival location"
      end

      swagger_model :ShowOrder do
        property :order, nil, :required, "Order", "$ref" => :Order
      end
    end
  end
end

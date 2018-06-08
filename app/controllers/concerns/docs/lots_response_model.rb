# frozen_string_literal: true

module Docs
  module LotsResponseModel
    extend ActiveSupport::Concern
    included do

      swagger_model :LotWithBids do |api|
        description "A Lot object."
        ApiController::LotsController.add_common_property api
        property :bids, :array, :required, "Bids", items: { "$ref" => :ShowBid }
      end

      swagger_model :Lot do |api|
        ApiController::LotsController.add_common_property api
      end

      swagger_model :ShowLotWithBids do
        property :lot, nil, :required, "Lot", "$ref" => :LotWithBids
      end
      swagger_model :ShowLot do
        property :lot, nil, :required, "Lot", "$ref" => :Lot
      end

      swagger_model :Lots do
        description "Lot objects."
        property :lots, :array, :required, "Lots", items: { "$ref" => :ShowLot }
      end

      def self.add_common_property(api)
        api.property :id, :integer, :required, "Lot Id"
        api.property :title, :string, :required, "Title"
        api.property :current_price, :float, :required, "Current price"
        api.property :estimated_price, :float, :required, "Estimated price"
        api.property :description, :string, :optional, "Description"
        api.property :image, :string, :optional, "Image"
        api.property_list :status, :string, :required, "Status", ["pending", "in_process", "closed"]
      end
    end
  end
end

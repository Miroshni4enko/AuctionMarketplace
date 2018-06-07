# frozen_string_literal: true

module Docs
  module BidsController
    extend ActiveSupport::Concern

    included do
      include Docs::BidsResponseModel
      include Swagger::Docs::Methods
      swagger_controller :bids, "Bids Management"

      swagger_api :create do
        summary "Creates a new Bid"
        param :path, :lot_id, :integer, :required, "ID of Lot"
        param :form, :proposed_price, :float, :required, "Proposed price"
        response :ok, "Success", :ShowBid
        response :unauthorized
        response :unprocessable_entity
        response :forbidden
      end

      swagger_api :index do
        summary "Get bids related to particular lot"
        param :path, :lot_id, :integer, :required, "ID of Lot"
        response :ok, "Success", :Bids
        response :unauthorized
      end

    end
  end
end

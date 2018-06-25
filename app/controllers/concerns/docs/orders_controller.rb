
# frozen_string_literal: true

module Docs
  module OrdersController
    extend ActiveSupport::Concern

    included do
      include Docs::OrdersResponseModel
      include Swagger::Docs::Methods
      swagger_controller :orders, "Orders Management"

      swagger_api :create do
        summary "Creates a new Order"
        param :path, :lot_id, :integer, :required, "ID of Lot"
        param :form, :arrival_type, :string, :required, "Arrival type"
        param :form, :arrival_location, :string, :required, "Arrival location"
        response :ok, "Success", :ShowOrder
        response :unauthorized
        response :unprocessable_entity
        response :forbidden
      end

      swagger_api :update do
        summary "Update order"
        param :path, :lot_id, :integer, :required, "ID of Lot"
        param :form, :arrival_type, :string,  "Arrival type"
        param :form, :arrival_location, :string,  "Arrival location"
        response :ok, "Success", :ShowOrder
        response :unauthorized
        response :unprocessable_entity
        response :forbidden
      end

      swagger_api :_send_ do
        summary "Send order"
        param :path, :lot_id, :integer, :required, "ID of Lot"
        response :ok, "Success", :ShowOrder
        response :unauthorized
        response :unprocessable_entity
        response :forbidden
      end

      swagger_api :deliver do
        summary "Deliver order"
        param :path, :lot_id, :integer, :required, "ID of Lot"
        response :ok, "Success", :ShowOrder
        response :unauthorized
        response :unprocessable_entity
        response :forbidden
      end



    end
  end
end

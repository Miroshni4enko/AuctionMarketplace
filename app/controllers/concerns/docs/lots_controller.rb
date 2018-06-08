# frozen_string_literal: true

module Docs
  module LotsController
    extend ActiveSupport::Concern
    included do
      include Swagger::Docs::Methods
      include Docs::BidsResponseModel
      include Docs::LotsResponseModel

      swagger_controller :lots, "Lots Management"

      swagger_api :index do |api|
        summary "Get all lots"
        ApiController::LotsController.add_pagination_params(api)
        response :ok, "success", :Lots
        response :unauthorized
        response :not_found
      end

      swagger_api :my do |api|
        summary "Fetches current user lots filter by criteria"
        notes "make sure you pass filter parameter"
        param_list :path, :filter, :string, :required, "filter", %w(created participation all)
        ApiController::LotsController.add_pagination_params(api)
        response :ok, "success", :Lots
        response :unauthorized
        response :not_found
      end

      swagger_api :show do
        summary "Get a Lot"
        notes "get information of lot by passing lot id"
        param :path, :id, :integer, :required, "ID of Lot"
        response :ok, "Success", :ShowLotWithBids
        response :not_found
        response :unauthorized
      end

      swagger_api :create do |api|
        summary "Creates a new Lot"
        ApiController::LotsController.add_common_params(api)
        response :ok, "Success", :Lot
        response :unauthorized
        response :unprocessable_entity
      end

      swagger_api :update do |api|
        summary "Update Lot"
        notes "make sure you pass parameters in lot's hash:"
        param :path, :id, :integer, :required, " of Lot"
        ApiController::LotsController.add_common_params(api)
        response :ok
        response :unprocessable_entity
      end

      swagger_api :destroy do
        summary "Delete a Lot"
        notes "Delete Lot by passing lot id"
        param :path, :id, :integer, :required, "ID of Lot"
        response :ok
        response :not_found
      end

      def self.add_common_params(api)
        api.param :form, :title, :string, :required, "Title"
        api.param :form, :current_price, :float, :required, "Current price"
        api.param :form, :estimated_price, :float, :required, "Estimated price"
        api.param :form, :description, :string, :optional, "Description"
        api.param :form, :image, :string, :optional, "Image"
        # api.param_list :form, :status, :string, :required, "Status", [ "pending", "in_process", "closed" ]
      end

      def self.add_pagination_params(api)
        api.param :query, :page, :integer, :optional, "Pagination page number"
        api.param :query, :per_page, :integer, :optional, "Number of items per page"
      end

    end
  end
end

# frozen_string_literal: true

class ApiController < ApplicationController
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound,       with: :not_found
  rescue_from ActionController::ParameterMissing, with: :missing_param_error

  def not_found
    render status: :not_found, json: ""
  end

  def missing_param_error(exception)
    render status: :unprocessable_entity, json: { error: exception.message }
  end


  class << self
    Swagger::Docs::Generator.set_real_methods

    def inherited(subclass)
      super
      subclass.class_eval do
        setup_basic_api_documentation
      end
    end

    private
    def setup_basic_api_documentation
      [:index, :show, :create, :update, :delete, :my].each do |api_action|
        swagger_api api_action do
          param :header, "uid", :string, :required, "uid"
          param :header, "access-token", :string, :required, "access-token"
          param :header, "client", :string, :required, "client"
        end
      end
    end
  end

  private

    def set_pending_lot
      @lot = current_user.lots.find(lot_params[:id])
      if @lot.status != "pending"
        render json: { error: "Status must be pending" }, status: :unprocessable_entity
      end
    end


    def pagination(paginated_array, per_page = Kaminari.config.default_per_page)
      { pagination: { per_page: per_page.to_i,
                    total_pages: paginated_array.total_pages,
                    total_lots: paginated_array.total_count } }
    end

    def render_collection(collection, options = {})
      page_of_collection = collection.page(params[:page])
      render ({ json: page_of_collection, meta: pagination(page_of_collection) }).merge! options
    end
end

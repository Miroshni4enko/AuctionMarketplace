# frozen_string_literal: true

class ApiController < ApplicationController
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

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {error: exception}, status: :not_found
  end
  private
    def lot_not_found
      render json: { error: "Lot did not found" }, status: :not_found
    end
end

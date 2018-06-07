# frozen_string_literal: true

module Docs::Users
  module SessionsController
    extend ActiveSupport::Concern
    included do
      include Swagger::Docs::Methods
      swagger_controller :sessions, "User Management"

      swagger_api :create do
        summary "Creates new user"
        param :form, :email, :string, :required, "Email"
        param :form, :password, :string, :required, "Password"
        response :unauthorized
      end

      swagger_api :destroy do
        summary "Deletes an existing User item"
        param :path, :id, :integer, :optional, "User Id"
        response :unauthorized
        response :not_found
      end
    end
  end
end

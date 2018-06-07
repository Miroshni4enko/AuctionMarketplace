# frozen_string_literal: true

module Docs::Users
  module PasswordsController
    extend ActiveSupport::Concern

    included do
      include Swagger::Docs::Methods
      swagger_controller :passwords, "Passwords"

      swagger_api :create do
        summary "Reset password"
        param :form, :email, :string, :required, "Email"
        response :unauthorized
        response :not_acceptable
      end

    end
  end
end

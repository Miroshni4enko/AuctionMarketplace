# frozen_string_literal: true

module Docs::Users
  module RegistrationsController
    extend ActiveSupport::Concern

    included do
      include Swagger::Docs::Methods
      swagger_controller :registrations, "User form registration"

      swagger_api :create do
        summary "Creates new user"
        param :form, :first_name, :string, :required, "Name"
        param :form, :last_name, :string, :required, "Surname"
        param :form, :birthday, :date, :required, "Birthday"
        param :form, :email, :string, :required, "Email"
        param :form, :phone, :string, :required, "Phone"
        param :form, :password, :string, :required, "Password"
        param :form, :password_confirmation, :string, :required, "Password confirmation"
        response :forbidden
      end
    end
  end
end

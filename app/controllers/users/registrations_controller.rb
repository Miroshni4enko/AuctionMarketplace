# frozen_string_literal: true

class Users::RegistrationsController < DeviseTokenAuth::RegistrationsController
  include Docs::Users::RegistrationsController
end

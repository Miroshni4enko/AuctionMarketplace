# frozen_string_literal: true

class Users::PasswordsController < DeviseTokenAuth::PasswordsController
  include Docs::Users::PasswordsController
end

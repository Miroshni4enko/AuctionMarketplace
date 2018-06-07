# frozen_string_literal: true

class Users::SessionsController < DeviseTokenAuth::SessionsController
  include Docs::Users::SessionsController
end

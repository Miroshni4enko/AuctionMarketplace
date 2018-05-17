# frozen_string_literal: true

class Api::V1::UserController < ApplicationController
  before_action :authenticate_api_v1_user!
  def members_only
    render json: {
      data: {
        message: "Welcome #{current_api_v1_user.email}",
        user: current_api_v1_user
      }
    }, status: 200
  end
end

# frozen_string_literal: true

class ApiController < ApplicationController
  private

    def lot_not_found
      render json: { error: "Lot did not found" }, status: :not_found
    end
end

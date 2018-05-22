# frozen_string_literal: true

class LotSerializer < ActiveModel::Serializer
  attributes :id, :image, :title, :description, :current_price, :created_at,
             :estimated_price, :lot_start_time, :lot_end_time, :status
end

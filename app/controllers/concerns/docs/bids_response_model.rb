# frozen_string_literal: true

module Docs
  module BidsResponseModel
    extend ActiveSupport::Concern
    included do
      swagger_model :Bid do
        property :id, :integer, :required, "ID of Bid"
        property :customer_name, :string, :required, "Customer name"
        property :proposed_price, :float, :required, "Proposed price"
        property :created_at, :date, :required, "Created at"
      end

      swagger_model :ShowBid do
        property :bid, nil, :required, "Bid", "$ref" => :Bid
      end

      swagger_model :Bids do
        description "Bid objects."
        property :bids, :array, :required, "Bids", items: { "$ref" => :ShowBid }
      end
    end
  end
end

# frozen_string_literal: true

class LotWithAssociationSerializer < LotSerializer
  has_one :order, serializer: OrderSerializer
  has_many :bids, serializer: BidSerializer
end

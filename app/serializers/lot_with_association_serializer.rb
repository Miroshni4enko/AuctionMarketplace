# frozen_string_literal: true

class LotWithAssociationSerializer < LotSerializer
  has_many :bids
end

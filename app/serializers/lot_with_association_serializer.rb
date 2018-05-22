class LotWithAssociationSerializer < LotSerializer
  has_many :bids
end

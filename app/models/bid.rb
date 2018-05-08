class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :lot
  has_one :order, dependent: :destroy

  validates :bid_creation_time, :proposed_price, presence: true
  validates :proposed_price, numericality: {greater_than_or_equal_to: 0 }

end

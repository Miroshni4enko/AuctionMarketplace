class Lot < ApplicationRecord
  belongs_to :user
  has_one :order, through: :bid
end

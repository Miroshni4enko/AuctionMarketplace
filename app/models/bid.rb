class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :lot
  has_one :order
end

class User < ApplicationRecord
  has_many :lots, dependent: :destroy
  has_many :bids, dependent: :destroy
end

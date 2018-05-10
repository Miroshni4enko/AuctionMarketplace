# == Schema Information
#
# Table name: bids
#
#  id                :bigint(8)        not null, primary key
#  user_id           :bigint(8)
#  lot_id            :bigint(8)
#  bid_creation_time :datetime         not null
#  proposed_price    :float            not null
#

class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :lot
  has_one :order, dependent: :destroy

  validates :bid_creation_time, :proposed_price, presence: true
  validates :proposed_price, numericality: {greater_than_or_equal_to: 0 }
  validates :bid_creation_time, times_in_the_future: true
end

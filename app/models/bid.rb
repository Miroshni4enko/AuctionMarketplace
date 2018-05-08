# == Schema Information
#
# Table name: bids
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  lot_id            :integer
#  bid_creation_time :datetime         not null
#  proposed_price    :float            not null
#

class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :lot
  has_one :order, dependent: :destroy

  validates :bid_creation_time, :proposed_price, presence: true
  validates :proposed_price, numericality: {greater_than_or_equal_to: 0 }

end

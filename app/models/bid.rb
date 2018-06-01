# frozen_string_literal: true

# == Schema Information
#
# Table name: bids
#
#  id             :bigint(8)        not null, primary key
#  proposed_price :float            not null
#  created_at     :datetime         not null
#  lot_id         :bigint(8)
#  user_id        :bigint(8)
#
# Indexes
#
#  index_bids_on_lot_id   (lot_id)
#  index_bids_on_user_id  (user_id)
#

class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :lot
  has_one :order, dependent: :destroy
  validates :proposed_price, presence: true
  validates :proposed_price, numericality: { greater_than_or_equal_to: 0 }
  after_create :check_lot_prices

  def check_lot_prices
    lot = Lot.find(lot_id)
    lot.check_prices self if lot
  end
end

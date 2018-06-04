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
  validate :check_proposed_price
  after_create :check_bid_is_winner
  after_create :update_current_price_of_lot

  def check_bid_is_winner
    self.lot.check_estimated_prices self
  end

  def update_current_price_of_lot
    lot.current_price = proposed_price
    lot.winning_bid = id
    save
  end

  def check_proposed_price
    if proposed_price <= lot.current_price
      errors.add(:proposed_price, "can't be less than current lot price")
    end
  end
end

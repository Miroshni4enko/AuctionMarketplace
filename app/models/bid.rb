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
  validates :proposed_price, presence: true
  validates :proposed_price, numericality: { greater_than_or_equal_to: 0 }
  validate :proposed_price_validation
  validate :lot_status_validation, on: :create
  after_create :update_lot_by_created_bid
  after_create :check_bid_is_winner
  after_create :perform_broadcast

  def check_bid_is_winner
    if proposed_price >= lot.estimated_price
      lot.close_lot
    end
  end

  def update_lot_by_created_bid
    lot.current_price = proposed_price
    lot.winning_bid = id
    lot.winner = user_id
    lot.save!
  end

  def proposed_price_validation
    if proposed_price <= lot.current_price
      errors.add(:proposed_price, "can't be less than current lot price")
    end
  end

  def serialize_bid
    serializer = BidSerializer.new(self)
    ActiveModelSerializers::Adapter.create(serializer).as_json
  end

  def perform_broadcast
    BidBroadcastWorker.perform_async(serialize_bid)
  end

  def lot_status_validation
    unless lot.in_process?
      errors.add("lot.status", "must be in process")
    end
  end
end

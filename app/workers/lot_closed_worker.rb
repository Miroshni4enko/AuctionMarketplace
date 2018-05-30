# frozen_string_literal: true

class LotClosedWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"

  def perform(lot_id)
    lot = Lot.find lot_id
    lot.status = :closed
    win_id = lot.bids.order(proposed_price: :desc, created_at: :desc).first
    lot.winning_bid = win_id
    lot.save
  end
end

# frozen_string_literal: true

class BidBroadcastWorker
  include Sidekiq::Worker
  sidekiq_options queue: "default"

  def perform(bid)
    ActionCable.server.broadcast "bids_for_lot_#{bid["lot_id"]}_channel", bid: bid.to_json
  end
end

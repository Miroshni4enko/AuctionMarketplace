# frozen_string_literal: true

class BidsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "bids_for_lot_#{params['lot_id']}_channel"
  end
end

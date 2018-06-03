# frozen_string_literal: true

class BidsChannel < ApplicationCable::Channel
  def subscribed
    if params["lot_id"]
      stream_from "bids_for_lot_#{params['lot_id']}_channel"
    else
      reject
    end
  end
end

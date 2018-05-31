# frozen_string_literal: true

class BidsController < ApiController
  before_action :authenticate_user!

  def create
    lot == Lot.find(lot_id)
    if  lot && lot.in_process?
      bid = current_user.bids.build(lot_params).build(bid_params)
      return render json: bid, status: :created, location: bid_url(bid) if bid.save
    end
    render json: bid.errors, status: :unprocessable_entity
  end

  def bid_params
    params.permit(:id, :lot_id, :proposed_price, :created_at)
  end
end

# frozen_string_literal: true

class BidsController < ApiController
  include Docs::BidsController
  before_action :authenticate_user!
  before_action :check_lot_not_pending, only: :index

  def create
    lot = Lot.find(bid_params[:lot_id])
    if current_user.id != lot.user_id
      bid = current_user.bids.build(bid_params)
      if bid.save
        render json: bid, status: :created, serializer: BidSerializer
      else
        render json: bid.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Current user can't create bid" }, status: :forbidden
    end
  end


  def index
    bids = @lot.bids
    render json: bids, each_serializer: BidSerializer, current_user_id: current_user.id
  end

  private

    def check_lot_not_pending
      @lot = Lot.find(bid_params[:lot_id])
      if @lot.pending?
        render json: { error: "Lot should be not pending" }, status: :forbidden
      end
    end

    def bid_params
      params.permit(:id, :lot_id, :proposed_price)
    end
end

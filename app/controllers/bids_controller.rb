# frozen_string_literal: true

class BidsController < ApiController
  include Docs::BidsController
  before_action :authenticate_user!
  before_action :check_lot_not_pending, only: :index

  def create
    lot = Lot.find(bid_params[:lot_id])
    if current_user.id != lot.user_id
      bid = current_user.bids.build(bid_params)
      bid.save
      render_record_or_errors bid, serializer: BidSerializer
    else
      render json: { error: "Current user can't create bid" }, status: :forbidden
    end
  end


  def index
    bids = @lot.bids.page(bid_params[:page])
    render_collection bids, each_serializer: BidSerializer, current_user_id: current_user.id
  end

  private

    def check_lot_not_pending
      @lot = Lot.find(bid_params[:lot_id])
      if @lot.pending?
        render json: { error: "Lot should be not pending" }, status: :forbidden
      end
    end

    def bid_params
      params.permit(:lot_id, :proposed_price, :page)
    end
end

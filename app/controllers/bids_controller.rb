# frozen_string_literal: true

class BidsController < ApiController
  before_action :authenticate_user!
  before_action :check_lot_in_process, only: :create
  before_action :check_lot_not_pending, only: :index


  def create
    if current_user.id != @lot.user_id
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

    def check_lot_in_process
      @lot = Lot.find(bid_params[:lot_id])
      unless @lot && @lot.in_process?
        lot_not_found
      end
    end

    def check_lot_not_pending
      @lot = Lot.find(bid_params[:lot_id])
      unless @lot && !@lot.pending?
        lot_not_found
      end
    end

    def bid_params
      params.permit(:id, :lot_id, :proposed_price)
    end
end

# frozen_string_literal: true

class BidsController < ApiController
  include Docs::BidsController
  before_action :find_lot
  before_action :require_not_seller, only: :create
  before_action :check_lot_not_pending, only: :index

  def create
    bid = current_user.bids.build(bid_params)
    bid.save
    render_record_or_errors bid, serializer: BidSerializer
  end

  def index
    bids = @lot.bids.page(bid_params[:page])
    render_collection bids, each_serializer: BidSerializer, current_user_id: current_user.id
  end

  private

  def require_not_seller
    if current_user.id == @lot.user_id
      render json: {error: "Seller can't create bid"}, status: :forbidden
    end
  end

  def check_lot_not_pending
    if @lot.pending?
      render json: {error: "Lot should be not pending"}, status: :forbidden
    end
  end

  def bid_params
    params.permit(:lot_id, :proposed_price, :page)
  end

  def find_lot
    @lot = Lot.find(bid_params[:lot_id])
  end
end

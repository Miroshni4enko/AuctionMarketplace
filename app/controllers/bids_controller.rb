class BidsController < ApiController
  before_action :authenticate_user!

  def create
    bid = Bid.build(bid_params)
    if bid.save
      render json: bid, status: :created, location: bid_url(bid)
    else
      render json: bid.errors, status: :unprocessable_entity
    end
  end

  def bid_params
    params.permit(:id, :lot_id, :proposed_price, :created_at)
  end
end

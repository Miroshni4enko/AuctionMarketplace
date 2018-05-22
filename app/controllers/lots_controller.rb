class LotsController < ApplicationController
  before_action :authenticate_user!

  def index
    lots = Lot.in_process.page(params[:page])
    render json: lots, meta: pagination(lots), each_serializer: LotSerializer
  end

  def my
    my_lots = Lot
                  .left_joins(:bids)
                  .where("lots.user_id": current_user.id)
                  .or(Lot.left_joins(:bids).where("bids.user_id": current_user.id))
                  .page(params[:page])

    render json: my_lots, meta: pagination(my_lots), each_serializer: LotSerializer
  end

  def show
    lot = Lot
               .find(params[:id])
               .where(user_id: current_user.id)
               .or(Lot.where(status: :in_process))
               .left_joins(:bids)
               .or(Lot.left_joins(:bids).where("bids.user_id": current_user.id))

    if lot
      render json: lot, serializer: LotWithAssociationSerializer
    else
      render_not_found 'Object not found'
    end
  end

  def create
    lot = current_user.lots.build(lot_params)
    if lot.save
      render json: lot, status: :created, location: lot_url(lot)
    else
      render json: lot.errors, status: :unprocessable_entity
    end
  end

  def update
    lot = current_user.lots.where("lots.id": lot_params[:id]).where.not(status: :in_process)
    if lot && lot.update_all(lot_params.to_hash)
      render status: 200, json: lot
    else
      render json: lot.errors, status: :unprocessable_entity
    end
  end

  def destroy
    lot = current_user.lots.where("lots.id": lot_params[:id]).where.not(status: :in_process)
    if lot
      lot.destroy
      render status: 200, format: :json
    else
      render_not_found "Object not found, or can't be deleted"
    end
  end

  private

  def lot_params
    params.permit(:lot, :image, :id, :title, :description, :current_price, :created_at,
                  :estimated_price, :lot_start_time, :lot_end_time, :status)
  end

  def pagination(paginated_array, per_page = 10)
    {pagination: {per_page: per_page.to_i,
                  total_pages: paginated_array.total_pages,
                  total_lots: paginated_array.total_count}}
  end
end

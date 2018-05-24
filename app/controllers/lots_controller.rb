# frozen_string_literal: true

class LotsController < ApiController
  before_action :authenticate_user!

  def index
    criteria = params[:criteria]
    if criteria
      if criteria == "created"
        lots = current_user.lots.page(params[:page])
      elsif criteria == "participation"
        # TODO rewrite to something like user.lots.bids
        lots = Lot.joins(:bids).where(bids: { user_id: current_user.id }).page(params[:page])
      elsif criteria == "all"
        lots = Lot.in_process.page(params[:page])
      end
    end

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
      render_not_found "Object not found"
    end
  end

  def create
    lot = current_user.lots.build(lot_params)
    if lot.save
      LotStatusUpdateWorker.perform_at(lot.lot_start_time, lot.id, :in_process) if lot.status == :pending
      LotStatusUpdateWorker.perform_at(lot.lot_end_time, lot.id, :closed)
      render json: lot, status: :created, location: lot_url(lot)
    else
      render json: lot.errors, status: :unprocessable_entity
    end
  end

  def update
    lot = current_user.lots.where("lots.id": lot_params[:id]).where.not(status: :in_process)
    if lot && lot.present? && lot.update_all(lot_params.to_hash)
      check_start_and_end_time
      render status: 200, json: lot
    else
      render json: (lot.errors if lot.present?), status: :unprocessable_entity
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
      params.permit(:id, :lot, :image, :remove_image, :image_cache, :title, :description, :current_price, :created_at,
                    :estimated_price, :lot_start_time, :lot_end_time, :status, :criteria)
    end

    def pagination(paginated_array, per_page = 10)
      { pagination: { per_page: per_page.to_i,
                    total_pages: paginated_array.total_pages,
                    total_lots: paginated_array.total_count } }
    end

    def check_start_and_end_time
      if lot_params[:lot_start_time]
        delete_update_status_job lot_params[:id], :in_process
        LotStatusUpdateWorker.perform_at(lot_params[:lot_start_time], lot_params[:id], :in_process)
      end

      if lot_params[:lot_end_time]
        delete_update_status_job lot_params[:id], :closed
        LotStatusUpdateWorker.perform_at(lot_params[:lot_end_time], lot_params[:id], :closed)
      end
    end
end

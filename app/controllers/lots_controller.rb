# frozen_string_literal: true

class LotsController < ApiController
  include Filterable
  include Docs::LotsController
  before_action :set_pending_lot, only: [:update, :destroy]

  def index
    lots = Lot.in_process.page(lot_params[:page])
    render_collection lots, each_serializer: LotSerializer
  end

  def show
    lot = Lot.find(lot_params[:id])
    users_id = lot.bids.map(&:id)
    if lot.user_id == current_user.id || users_id.include?(current_user.id)
      render_record_or_errors lot
    else
      render status: :forbidden
    end
  end

  def create
    lot = current_user.lots.build(lot_params)
    lot.save
    render_record_or_errors lot
  end

  def update
    @lot.update(lot_params)
    render_record_or_errors @lot
  end

  def destroy
    @lot.destroy
    render status: 200
  end

  private

    def set_pending_lot
      @lot = current_user.lots.find(lot_params[:id])
      if @lot.status != "pending"
        render json: { error: "Status must be pending" }, status: :unprocessable_entity
      end
    end

    def render_record_or_errors(item)
      if item.errors.present?
        render json: { errors: item.errors }, status: :unprocessable_entity
      else
        render json: item, status: 200, serializer: LotWithAssociationSerializer
      end
    end

    def lot_params
      params.permit(:id, :lot, :image, :remove_image, :image_cache, :title, :description, :current_price, :created_at,
                    :estimated_price, :lot_start_time, :lot_end_time, :page)
    end
end

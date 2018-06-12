# frozen_string_literal: true

class LotsController < ApiController
  include Docs::LotsController
  before_action :authenticate_user!
  before_action :set_pending_lot, only: [:update, :destroy]

  def index
    lots = Lot.in_process.page(lot_params[:page])
    render_collection lots
  end

  def my
    my_lots = Lot.matching_filter_by_user(lot_params[:filter], current_user)
    render_collection my_lots
  end

  def show
    lot = Lot.get_to_show(lot_params[:id], current_user).first
    render_record_or_errors lot
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
      render json: {error: "Status must be pending"}, status: :unprocessable_entity
    end
  end

  def render_record_or_errors(item)
    if item.errors.present?
      render json: {errors: item.errors}, status: :unprocessable_entity
    else
      render json: item, status: 200
    end
  end

  def render_collection(collection)
    page_of_collection = collection.page(params[:page])
    render json: page_of_collection, meta: pagination(page_of_collection), each_serializer: LotSerializer
  end

  def lot_params
    params.permit(:id, :lot, :image, :remove_image, :image_cache, :title, :description, :current_price, :created_at,
                  :estimated_price, :lot_start_time, :lot_end_time, :filter, :page)
  end

  def pagination(paginated_array, per_page = 10)
    {pagination: {per_page: per_page.to_i,
                  total_pages: paginated_array.total_pages,
                  total_lots: paginated_array.total_count}}
  end
end

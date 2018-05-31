# frozen_string_literal: true

class LotsController < ApiController
  before_action :authenticate_user!

  def index
    lots = Lot.in_process.page(lot_params[:page])
    render json: lots, meta: pagination(lots), each_serializer: LotSerializer
  end

  def my
    my_lots = Lot.matching_filter_by_user(lot_params[:filter], current_user).page(params[:page])
    render json: my_lots, meta: pagination(my_lots), each_serializer: LotSerializer
  end

  def show
    lot = Lot.show(lot_params[:id], current_user).scoping do
      Lot.first # SELECT * FROM comments WHERE post_id = 1
    end
    if lot
      render json: lot, serializer: LotWithAssociationSerializer
    else
      render_not_found "Object not found"
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
    # SELECT "lots".* FROM "lots" WHERE "lots"."user_id" = $1 AND "lots"."id" = $2 AND "lots"."status" != $3
    lot = Lot.pending_lot_by_user(lot_params[:id], current_user).scoping do
      Lot.first # SELECT * FROM comments WHERE post_id = 1
    end
    # return - https://www.rubydoc.info/docs/rails/4.1.7/ActiveRecord/AssociationRelation
    # if lot - not request query, only check on nil
    if lot.present? && lot.update(lot_params)
      render status: 200, json: lot
    else
      render json: (lot.errors if lot.present?), status: :unprocessable_entity
    end
  end

  def destroy
    lot = Lot.pending_lot_by_user(lot_params[:id], current_user).scoping do
      Lot.first # SELECT * FROM comments WHERE post_id = 1
    end
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
                    :estimated_price, :lot_start_time, :lot_end_time, :status, :filter, :page)
    end

    def pagination(paginated_array, per_page = 10)
      { pagination: { per_page: per_page.to_i,
                    total_pages: paginated_array.total_pages,
                    total_lots: paginated_array.total_count } }
    end
end

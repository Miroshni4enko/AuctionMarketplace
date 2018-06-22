# frozen_string_literal: true

class OrdersController < ApiController
  before_action :find_lot
  before_action :require_customer, only: [:create, :update, :deliver]
  before_action :require_seller, only: [:_send_]

  def create
    order = @lot.build_order(order_params)
    order.save
    render_record_or_errors order, serializer: OrderSerializer
  end

  def update
    order = Order.find(order_params[:id])
    order.update(order_params)
    render_record_or_errors order, serializer: OrderSerializer
  end

  def _send_
    change_status_to :sent
  end

  def deliver
    change_status_to :delivered
  end

  private

    def change_status_to(status)
      order = @lot.order
      order.update(status: status)
      render_record_or_errors order, serializer: OrderSerializer
    end

    def require_customer
      check_current_user @lot.winner
    end

    def require_seller
      check_current_user @lot.user_id
    end

    def check_current_user(user_id)
      if current_user.id != user_id
        render json: { error: "Current user can't perform this action" }, status: :forbidden
      end
    end

    def order_params
      params.permit(:id, :lot_id, :arrival_type, :arrival_location)
    end

    def find_lot
      @lot = Lot.find(order_params[:lot_id])
    end
end

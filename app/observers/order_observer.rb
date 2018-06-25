class OrderObserver < ActiveRecord::Observer
  def after_create(order)
    NotifySellerMailer.order_created_email(order.lot.user, order.lot, order).deliver_later
  end

  def after_save(order)
    if order.status_changed_to? "sent"
      NotifyCustomerMailer.order_sent_email(User.find(order.lot.winner), order.lot, order).deliver_later
    end

    if order.status_changed_to? "delivered"
      NotifyCustomerMailer.order_delivered_email(User.find(order.lot.winner), order.lot).deliver_later
      NotifySellerMailer.order_delivered_email(order.lot.user, order.lot).deliver_later
    end
  end

end

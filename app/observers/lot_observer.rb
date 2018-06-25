class LotObserver < ActiveRecord::Observer
  def after_save(lot)
    if lot.status_changed_to? "closed"
      NotifyCustomerMailer.winning_email(User.find(lot.winner), lot).deliver_later
      NotifySellerMailer.lot_closed_email(lot.user, lot).deliver_later
    end
  end
end
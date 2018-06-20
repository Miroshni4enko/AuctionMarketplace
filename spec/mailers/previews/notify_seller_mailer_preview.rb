# Preview all emails at http://localhost:3000/rails/mailers/notify_seller_mailer
class NotifySellerMailerPreview < ActionMailer::Preview

  def lot_closed_email
    @user = User.new(first_name: "Vasia", email: "examle@rails.com")
    @lot = Lot.new(title: "Keys from castle", id: -3, current_price: 20.00)
    NotifySellerMailer.lot_closed_email(@user, @lot)
  end
end

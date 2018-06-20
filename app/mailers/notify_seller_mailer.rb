class NotifySellerMailer < ApplicationMailer
  def lot_closed_email(user, lot)
    @user = user
    @lot  = lot
    @url = "#{frontend_url}/api/lots/#{@lot.id}"
    mail(to: @user.email, subject: "Lot '#{@lot.title}' was sold")
  end
end

# frozen_string_literal: true

class NotifySellerMailer < ApplicationMailer
  def lot_closed_email(user, lot)
    @user = user
    @lot  = lot
    @url = "#{frontend_url}/api/lots/#{@lot.id}"
    mail(to: @user.email, subject: "Lot '#{@lot.title}' was sold")
  end

  def order_delivered_email(user, lot)
    @user = user
    @lot  = lot
    @url = "#{frontend_url}/api/lots/#{@lot.id}"
    mail(to: @user.email, subject: "Order for  '#{@lot.title}' lot was successfully delivered")
  end

  def order_created_email(user, lot, order)
    @user = user
    @lot  = lot
    @order = order
    @url = "#{frontend_url}/api/lots/#{@lot.id}"
    mail(to: @user.email, subject: "Order for  '#{@lot.title}' lot was created")
  end
end

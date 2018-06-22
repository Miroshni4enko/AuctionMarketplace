# frozen_string_literal: true

class NotifyCustomerMailer < ApplicationMailer
  def winning_email(user, lot)
    @user = user
    @lot  = lot
    @url = "#{frontend_url}/api/lots/#{@lot.id}"
    mail(to: @user.email, subject: "You are winner")
  end

  def order_sent_email(user, lot, order)
    @user = user
    @lot  = lot
    @url = "#{frontend_url}/api/lots/#{@lot.id}"
    @order = order
    mail(to: @user.email, subject: "Order for  '#{@lot.title}' lot was sent")
  end

  def order_delivered_email(user, lot)
    @user = user
    @lot  = lot
    @url = "#{frontend_url}/api/lots/#{@lot.id}"
    mail(to: @user.email, subject: "Confirmation for '#{@lot.title}'")
  end
end

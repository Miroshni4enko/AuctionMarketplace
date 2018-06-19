# frozen_string_literal: true

class WinnerMailer < ApplicationMailer
  def winning_email(user, lot)
    @user = user
    @lot  = lot
    @url = "#{frontend_url}/api/lots/#{@lot.id}"
    mail(to: @user.email, subject: "You are winner")
  end
end

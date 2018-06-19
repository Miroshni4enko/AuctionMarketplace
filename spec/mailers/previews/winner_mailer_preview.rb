# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/winner_mailer

class WinnerMailerPreview < ActionMailer::Preview
  def winner_mailer
    @user = User.new(first_name: "Vasia", email: "examle@rails.com")
    @lot = Lot.new(title: "Keys from castle", id: -3)
    WinnerMailer.winning_email(@user, @lot)
  end
end

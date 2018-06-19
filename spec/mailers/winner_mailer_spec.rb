# frozen_string_literal: true

require "rails_helper"

RSpec.describe WinnerMailer, type: :mailer do
  describe "sending winning email " do

    it "should send email with appropriate params" do
      user = FactoryBot.create(:user)
      lot = FactoryBot.create(:lot, user: user)

      email = WinnerMailer.winning_email(user, lot).deliver_now

      expect(ActionMailer::Base.deliveries).to be

      expect(["from@example.com"]).to eq(email.from)
      expect([user.email]).to eq(email.to)
      expect("You are winner").to eq(email.subject)
    end

  end
end

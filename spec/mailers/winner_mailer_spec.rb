# frozen_string_literal: true

require "rails_helper"

RSpec.describe WinnerMailer, type: :mailer do
  describe "sending winning email " do
    before do
      @user = FactoryBot.create(:user)
      @lot = FactoryBot.create(:lot, user: @user)
      @email = WinnerMailer.winning_email(@user, @lot).deliver_now
    end
    
    it_behaves_like "mailers" do
      let(:email) {ActionMailer::Base.deliveries.last}
      let(:user) {@user}
      let(:subject) {"You are winner"}
    end
  end
end


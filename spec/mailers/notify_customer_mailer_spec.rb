# frozen_string_literal: true

require "rails_helper"

RSpec.describe NotifyCustomerMailer, type: :mailer do
  describe "sending winning email " do
    before do
      @user = create(:user)
      @lot = create(:lot, user: @user)
      @email = NotifyCustomerMailer.winning_email(@user, @lot).deliver_now
    end

    it_behaves_like "mailers" do
      let(:email) { ActionMailer::Base.deliveries.last }
      let(:user) { @user }
      let(:subject) { "You are winner" }
    end
  end

end

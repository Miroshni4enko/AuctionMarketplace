require "rails_helper"

RSpec.describe NotifySellerMailer, type: :mailer do
  describe "sending email about closing of lot  " do
    before do
      @user = FactoryBot.create(:user)
      @lot = FactoryBot.create(:lot, user: @user)
      @email = NotifySellerMailer.lot_closed_email(@user, @lot).deliver_now
    end
    it_behaves_like "mailers" do
      let(:email) {ActionMailer::Base.deliveries.last}
      let(:user) {@user}
      let(:subject) {"Lot '#{@lot.title}' was sold"}
    end
  end
end


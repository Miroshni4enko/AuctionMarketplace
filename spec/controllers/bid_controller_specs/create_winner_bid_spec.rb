# frozen_string_literal: true

require "rails_helper"

RSpec.describe BidsController, type: :controller do
  include ActiveJob::TestHelper
  describe "creating of winning bid" do
    before { ActionMailer::Base.deliveries = [] }
    let (:default_from_email) {["from@example.com"]}

    before :all do
      @user = FactoryBot.create(:user)
      @lot = FactoryBot.create(:lot, :with_in_process_status, user: @user)
      @another_user = FactoryBot.create(:user)
      proposed_price = @lot.estimated_price + 1.00
      @bid_params = FactoryBot.attributes_for(:bid, proposed_price: proposed_price, lot: @lot, user: @another_user)
    end

    before :each do
      login @another_user
      perform_enqueued_jobs do
        post :create, params: @bid_params.merge(lot_id: @lot.id)
      end
      @lot.reload
    end

    it "should add bid" do
      expect(@lot.bids.count).to eq(1)
    end

    it " should set winning bid" do
      expect(@lot.winning_bid).to eq(json_response_body[:bid][:id])
    end

    it "should close lot" do
      expect(@lot.status).to eq("closed")
    end

    it "should delete jid for job which change status to closed" do
      expect(@lot.lot_jid_closed).to be_nil
    end

    it "should send email about closing lot" do
      emails = ActionMailer::Base.deliveries
      lot_closed_subject = "Lot '#{@lot.title}' was sold"
      lot_closed_email = emails.find {|email| email.subject == lot_closed_subject}

      expect(default_from_email).to eq(lot_closed_email.from)
      expect([@user.email]).to eq(lot_closed_email.to)
      expect(lot_closed_subject).to eq(lot_closed_email.subject)
    end

    it "should send email about winning bid" do
      emails = ActionMailer::Base.deliveries
      winner_subject = "You are winner"
      winner_email = emails.find {|email| email.subject == winner_subject}

      expect(default_from_email).to eq(winner_email.from)
      expect([@another_user.email]).to eq(winner_email.to)
      expect(winner_subject).to eq(winner_email.subject)
    end
  end
end
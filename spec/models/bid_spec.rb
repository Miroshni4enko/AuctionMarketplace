# frozen_string_literal: true

# == Schema Information
#
# Table name: bids
#
#  id             :bigint(8)        not null, primary key
#  proposed_price :float            not null
#  created_at     :datetime         not null
#  lot_id         :bigint(8)
#  user_id        :bigint(8)
#
# Indexes
#
#  index_bids_on_lot_id   (lot_id)
#  index_bids_on_user_id  (user_id)
#

require "rails_helper"
RSpec.describe Bid, type: :model do

  it { is_expected.to callback(:perform_broadcast).after(:create) }

  it { is_expected.to callback(:update_lot_by_created_bid).after(:create) }

  it { is_expected.to callback(:check_bid_is_winner).after(:create) }


  describe "validation lot status " do
    it "must be in process after create" do
      @user = create(:user)
      @another_user = create(:user)
      pending_lot = create(:lot, status: :pending, user: @user)
      bid = build(:bid, lot: pending_lot, user: @another_user)
      bid.valid?
      expect(bid.errors["lot.status"]).to include("must be in process")
    end
  end


  describe "checking prices of lots" do

    before do
      @user = create(:user)
      @lot = create(:lot, :with_in_process_status, user: @user)
    end

    it "should update current price of lot" do
      bid = create(:bid, lot: @lot, user: @user)
      expect(@lot.current_price).to eq(bid.proposed_price)
      expect(@lot.winning_bid).to eq(bid.id)
    end

    it "check_bid_is_winner" do
      another_user = create(:user)
      proposed_price = @lot.estimated_price + 2.00
      create(:bid, proposed_price: proposed_price, lot: @lot, user: another_user)
      expect(@lot.status).to eq("closed")
      expect(@lot.lot_jid_closed).to eq(nil)
    end

    it "should restrict proposed price less than current" do
      bid = @lot.bids.new(proposed_price: 0.00)
      bid.valid?
      expect(bid.errors[:proposed_price]).to include("can't be less than current lot price")
    end
  end
end

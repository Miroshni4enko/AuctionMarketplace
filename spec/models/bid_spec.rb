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

  it { is_expected.to callback(:update_current_price_of_lot).after(:create) }

  it { is_expected.to callback(:check_bid_is_winner).after(:create) }

  it { is_expected.to callback(:check_bid_is_winner).after(:create) }

  describe "checking prices of lots" do

    before do
      @user = FactoryBot.create(:user)
      @lot = FactoryBot.create(:lot, :with_in_process_status, user: @user)
    end

    it "should update current price of lot" do
      bid = FactoryBot.build(:bid, lot: @lot, user: @user)
      bid.update_current_price_of_lot
      expect(@lot.current_price).to eq(bid.proposed_price)
      expect(@lot.winning_bid).to eq(bid.id)
    end

    it "check_bid_is_winner" do
      bid = @lot.bids.new(proposed_price: @lot.estimated_price + 2.00)
      bid.check_bid_is_winner
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

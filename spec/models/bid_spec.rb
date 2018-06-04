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
  describe "# validation of proposed price" do
    it "should restrict proposed price less than current" do
      current_user = FactoryBot.create(:user)
      lot = FactoryBot.create(:lot, :with_in_process_status, user: current_user)
      bid = lot.bids.new(proposed_price: 0.00)
      bid.valid?
      expect(bid.errors[:proposed_price]).to include("can't be less than current lot price")
    end
  end
end

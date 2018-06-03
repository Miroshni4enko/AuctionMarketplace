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
require "sidekiq/testing"
RSpec.describe Bid, type: :model do

  it { is_expected.to callback(:perform_broadcast).after(:create) }

=begin
TODO
  it "perform_broadcast should broadcast" do
    current_user = FactoryBot.create(:user)
    @lot = FactoryBot.create(:lot, user: current_user)
    @another_user = FactoryBot.create(:user)
    @bid =
    Sidekiq::Testing.inline! do
      expect {Bid.create(proposed_price: 213.23, lot: @lot, user: @another_user)}.to have_broadcasted_to("bids_for_lot_#{@lot.id}_channel")
    end
  end
=end
end

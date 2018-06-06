# frozen_string_literal: true

require "rails_helper"

RSpec.describe BidsChannel, type: :channel do

  it "rejects when no lot id" do
    subscribe
    expect(subscription).to be_rejected
  end

  it "subscribes to a stream when lot id is provided" do
    subscribe(lot_id: 42)
    expect(subscription).to be_confirmed
    expect(streams).to include("bids_for_lot_42_channel")
  end

end

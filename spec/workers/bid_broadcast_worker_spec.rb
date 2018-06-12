# frozen_string_literal: true

require "rails_helper"
require "sidekiq/testing"

RSpec.describe BidBroadcastWorker, type: :worker do
  setup do
    Sidekiq::Testing.fake!
  end

  before do
    current_user = FactoryBot.create(:user)
    @lot = FactoryBot.create(:lot, :with_in_process_status, user: current_user)
    @another_user = FactoryBot.create(:user)
    @bid = FactoryBot.create(:bid, lot: @lot, user: @another_user)
  end

  it { is_expected.to be_processed_in :default }

  it "should create job" do
    expect { BidBroadcastWorker.perform_async(@bid.as_json) }.to change(BidBroadcastWorker.jobs, :size).by(1)
  end

  it "should create job" do
    expect { FactoryBot.create(:bid, lot: @lot, user: @another_user) }.to change(BidBroadcastWorker.jobs, :size).by(1)
  end

  it "should broadcast" do
    Sidekiq::Testing.inline! do
      expect { BidBroadcastWorker.perform_async(@bid.as_json) }.to have_broadcasted_to("bids_for_lot_#{@lot.id}_channel")
    end
  end


end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe LotStatusUpdateWorker, type: :worker do
  before do
    current_user = FactoryBot.create(:user)
    @new_lot = FactoryBot.create(:lot, user: current_user)
  end
  it "should update lot's status from pending to in_process after lot_start_time" do
    subject.perform(@new_lot.id)
    @new_lot.reload
    expect(@new_lot.status).to eq("in_process")
  end

  it { is_expected.to be_processed_in :high }

  it "should execute in time" do
    jid =  LotStatusUpdateWorker.perform_at(@new_lot.lot_start_time, @new_lot.id)
    # expect(LotStatusUpdateWorker.jobs.size).to eq(1)
    expect(LotStatusUpdateWorker.jobs.find { |job| job["jid"] == jid }["at"]).to eq(@new_lot.lot_start_time.to_f)
  end
end

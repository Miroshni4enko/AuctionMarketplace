# frozen_string_literal: true

require "rails_helper"

RSpec.describe LotStatusUpdateWorker, type: :worker do
  before do
    current_user = create(:user)
    @new_lot = create(:lot, user: current_user)
  end

  it { is_expected.to be_processed_in :high }

  it "should execute in time" do
    jid =  LotStatusUpdateWorker.perform_at(@new_lot.lot_start_time, @new_lot.id, :in_process)
    # expect(LotStatusUpdateWorker.jobs.size).to eq(1)
    expect(LotStatusUpdateWorker.jobs.find { |job| job["jid"] == jid }["at"]).to eq(@new_lot.lot_start_time.to_f)
  end
end

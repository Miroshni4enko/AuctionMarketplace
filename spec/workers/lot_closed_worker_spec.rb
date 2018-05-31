# frozen_string_literal: true

require "rails_helper"
require "sidekiq/testing"

RSpec.describe LotClosedWorker, type: :worker do
  setup do
    Sidekiq::Testing.fake!
  end

  before do
    current_user = FactoryBot.create(:user)
    @new_lot = FactoryBot.create(:lot, user: current_user)
  end

=begin
  it "should update lot's status from in_process to closed after lot_end_time" do
    @new_lot.reload
    expect(@new_lot.status).to eq("closed")
  end
=end


  it { is_expected.to be_processed_in :high }

  it "should execute in time" do
    jid =  LotClosedWorker.perform_at(@new_lot.lot_start_time, @new_lot.id)
    # expect(LotStatusUpdateWorker.jobs.size).to eq(1)
    expect(LotClosedWorker.jobs.find { |job| job["jid"] == jid }["at"]).to eq(@new_lot.lot_start_time.to_f)
  end
end

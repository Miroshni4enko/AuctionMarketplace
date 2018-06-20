# frozen_string_literal: true

# == Schema Information
#
# Table name: lots
#
#  id                 :bigint(8)        not null, primary key
#  current_price      :float            not null
#  description        :text
#  estimated_price    :float            not null
#  image              :string
#  lot_end_time       :datetime         not null
#  lot_jid_closed     :string
#  lot_jid_in_process :string
#  lot_start_time     :datetime         not null
#  status             :integer          default("pending"), not null
#  title              :text             not null
#  winning_bid        :integer
#  created_at         :datetime         not null
#  user_id            :bigint(8)
#
# Indexes
#
#  index_lots_on_user_id  (user_id)
#

require "rails_helper"
RSpec.describe Lot, type: :model do

  it { is_expected.to callback(:create_jobs!).after(:create) }

  it { is_expected.to callback(:send_emails).after(:save) }

  it { is_expected.to callback(:update_jobs_by_start_and_end_time).before(:update) }

  describe "#lot_start_time" do
    it "lot_start_time cannot be in the past" do
      mock_lot = Lot.new lot_start_time: DateTime.parse("2000-12-03T04:05:06+07:00 ")
      mock_lot.valid?
      expect(mock_lot.errors[:lot_start_time]).to include("can't be in the past")
    end
  end

  describe "validation  created_status" do
    it "must be pending after create" do
      in_process_lot =  FactoryBot.build(:lot, status: :in_process)
      closed_lot = FactoryBot.build(:lot, status: :closed)
      in_process_lot.valid?
      closed_lot.valid?
      expect(in_process_lot.errors[:status]).to include ("must be pending")
      expect(closed_lot.errors[:status]).to include ("must be pending")
    end
  end

  describe "#lot_end_time" do
    it "lot_end_time cannot be less than lot_start_time" do
      mock_lot = Lot.new lot_start_time: DateTime.parse("2018-12-03T04:05:06+07:00 "),
                         lot_end_time: DateTime.parse("2017-12-03T04:05:06+07:00 ")
      mock_lot.valid? # run validators
      expect(mock_lot.errors[:lot_end_time]).to include("can't be less lot start time")
    end
  end

  describe "check_start_and_end_time callback" do
    before do
      user = FactoryBot.create(:user)
      @lot = FactoryBot.create(:lot, user: user)
    end

    it "should create update job for closes status" do
      jid_closed = @lot.lot_jid_closed
      @lot.update_attribute(:lot_jid_closed, @lot.lot_end_time - 1.hour)
      expect(@lot.lot_jid_closed).not_to eq(jid_closed)
    end

    it "should create update job for in process status" do
      jid_in_process = @lot.lot_jid_in_process
      @lot.update_attribute(:lot_start_time, @lot.lot_start_time - 1.hour)
      expect(@lot.lot_jid_in_process).not_to eq(jid_in_process)
    end

  end
end

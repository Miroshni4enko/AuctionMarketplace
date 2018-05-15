# frozen_string_literal: true

# == Schema Information
#
# Table name: lots
#
#  id              :bigint(8)        not null, primary key
#  user_id         :bigint(8)
#  title           :text             not null
#  image           :string
#  description     :text
#  status          :integer          default("pending"), not null
#  created_at      :datetime         not null
#  current_price   :float            not null
#  estimated_price :float            not null
#  lot_start_time  :datetime         not null
#  lot_end_time    :datetime         not null
#

require "rails_helper"
RSpec.describe Lot, type: :model do
  describe "#lot_start_time" do
    it "lot_start_time cannot be in the past," do
      mock_lot = Lot.new lot_start_time: DateTime.parse("2000-12-03T04:05:06+07:00 ")
      mock_lot.valid?
      expect(mock_lot.errors[:lot_start_time]).to include("can't be in the past")
    end
  end

  describe "#lot_end_time" do
    it "lot_end_time cannot be less than lot_start_time" do
      mock_lot = Lot.new  lot_start_time: DateTime.parse("2018-12-03T04:05:06+07:00 "),
                          lot_end_time: DateTime.parse("2017-12-03T04:05:06+07:00 ")
      mock_lot.valid? # run validators
      expect(mock_lot.errors[:lot_end_time]).to include("can't be less lot start time")
    end
  end
end

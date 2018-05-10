# == Schema Information
#
# Table name: bids
#
#  id                :bigint(8)        not null, primary key
#  user_id           :bigint(8)
#  lot_id            :bigint(8)
#  bid_creation_time :datetime         not null
#  proposed_price    :float            not null
#

require 'rails_helper'
RSpec.describe Bid, :type => :model do

  describe '#bid_creation_time' do

    it 'bid_creation_time cannot be in the past,' do
      mock_bid = Bid.new  bid_creation_time: DateTime.parse("2000-12-03T04:05:06+07:00 ")
      mock_bid.valid?
      expect(mock_bid.errors[:bid_creation_time]).to include("can't be in the past")
    end


  end

end

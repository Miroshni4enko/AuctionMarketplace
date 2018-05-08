# == Schema Information
#
# Table name: bids
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  lot_id            :integer
#  bid_creation_time :datetime         not null
#  proposed_price    :float            not null
#

require 'rails_helper'

RSpec.describe Bid, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

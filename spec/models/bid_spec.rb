# frozen_string_literal: true

# == Schema Information
#
# Table name: bids
#
#  id             :bigint(8)        not null, primary key
#  user_id        :bigint(8)
#  lot_id         :bigint(8)
#  created_at     :datetime         not null
#  proposed_price :float            not null
#

require 'rails_helper'
RSpec.describe Bid, type: :model do
end

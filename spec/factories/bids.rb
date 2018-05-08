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

FactoryBot.define do
  factory :bid do
    bid_creation_time "2018-05-07 17:07:53"
    proposed_price 1
    lot_id 1
    user_id 1
  end
end

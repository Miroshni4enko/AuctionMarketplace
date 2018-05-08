# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  bid_id           :integer
#  arrival_location :text             not null
#  arrival_type     :string           not null
#  status           :integer          not null
#

FactoryBot.define do
  factory :order do
    arrival_location "MyText"
    arrival_type "MyString"
    status "MyString"
    bid_id 1
  end
end

# == Schema Information
#
# Table name: lots
#
#  id              :integer          not null, primary key
#  user_id         :integer
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

FactoryBot.define do
  factory :lot do
    title "MyText"
    image "MyString"
    description "MyText"
    status "MyString"
    created_at "2018-05-07 17:18:18"
    current_price 1
    estimated_price 1
    lot_start_time "2018-05-07 17:18:18"
    lot_end_time "2018-05-07 17:18:18"
  end
end

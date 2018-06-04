# frozen_string_literal: true

#
FactoryBot.define do
  factory :bid, class: Bid  do
    association :lot, factory: :lot
    association :user, factory: :user
    proposed_price { self.lot.current_price + Faker::Commerce.price }
  end
end

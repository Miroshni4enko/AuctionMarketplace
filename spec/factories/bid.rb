# frozen_string_literal: true

#
FactoryBot.define do
  factory :bid, class: Bid  do
    association :lot, factory: :lot
    association :user, factory: :user
    proposed_price { self.lot.current_price + Faker::Commerce.price }
  end

  trait :with_created_at do
    created_at  { DateTime.now }
  end
  trait :with_id do
    id  { 13 }
  end
end

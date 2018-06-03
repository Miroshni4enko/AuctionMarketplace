# frozen_string_literal: true

#
FactoryBot.define do
  factory :bid, class: Bid do
    association :lot, factory: :lot
    association :user, factory: :user
    proposed_price { Faker::Commerce.price }

    trait :with_id do
      id  { 13 }
    end
  end
end


# frozen_string_literal: true

FactoryBot.define do
  factory :order, class: Order do
    association :lot, factory: :lot
    arrival_location { Faker::Address.full_address }
    arrival_type "Royal Mail"

    trait :with_sent_status do
      after(:create) do |order|
        order.update_attribute(:status, :sent)
      end
    end

    trait :with_delivered_status do
      after(:create) do |order|
        order.update_attribute(:status, :delivered)
      end
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :random_lot, class: Lot do
    association :user, factory: :user
    title { Faker::Name.title }
    description { Faker::Lorem.sentence(20, false, 0).chop }
    current_price { Faker::Commerce.price }
    estimated_price { current_price + Faker::Commerce.price }
    lot_start_time { DateTime.now + 8.days }
    lot_end_time { lot_start_time + 7.days }

    factory :random_lot_with_image do
      image Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, "spec/fixtures/files/lot_ex.jpg")))
    end

  end
end

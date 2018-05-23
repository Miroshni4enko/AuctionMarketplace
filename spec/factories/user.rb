# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { Faker::Internet.password }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.cell_phone }
    birthday { Faker::Date.birthday min_age = 21 }
    confirmed_at DateTime.now

    trait :unconfirmed do
      confirmed_at nil
    end

  end

end

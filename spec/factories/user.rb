# frozen_string_literal: true

FactoryBot.define do
  factory :random_user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { Faker::Internet.password }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.cell_phone }
    birthday { Faker::Date.birthday min_age = 21 }
  end

  factory :confirmed_random_user, parent: :random_user do
    confirmed_at DateTime.now
  end

end

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

  factory :random_user_with_success_url_for_sign_up, parent: :random_user do
    confirm_success_url "/"
  end

  factory :confirmed_random_user, parent: :random_user do
    confirmed_at DateTime.now
  end

end

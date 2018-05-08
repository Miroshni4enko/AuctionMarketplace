# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  phone      :string           not null
#  first_name :string           not null
#  last_name  :string           not null
#  date       :birthday         not null
#

FactoryBot.define do
  factory :user do
    email "MyString"
    phone "MyString"
    first_name "MyString"
    last_name "MyString"
    birthday "2018-05-07 16:59:32"
  end
end

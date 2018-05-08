# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  phone      :string           not null
#  first_name :string           not null
#  last_name  :string           not null
#  birthday   :date             not null
#

class User < ApplicationRecord
  has_many :lots, dependent: :destroy, inverse_of: :user
  has_many :bids, dependent: :destroy

  validates :email, :phone, :first_name, :last_name, :birthday, presence: true
  validates :email, :phone, uniqueness: true
  validates :email, email_format: { message: "doesn't look like an email address" }
  validate :birthday_must_be_more_than_21

  def birthday_cannot_be_less_than_21
    if ((birthday.to_date - Date.today) / 365.25) < 21.00
      errors.add(:birthday, "can't be less than 21")
    end
  end
end

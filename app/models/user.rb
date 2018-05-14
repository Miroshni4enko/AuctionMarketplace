# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           not null
#  phone                  :string           not null
#  first_name             :string           not null
#  last_name              :string           not null
#  birthday               :date             not null
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  allow_password_change  :boolean          default(FALSE)
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  tokens                 :json
#

class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  has_many :lots, dependent: :destroy, inverse_of: :user
  has_many :bids, dependent: :destroy

  validates :email, :phone, :first_name, :last_name, :birthday, presence: true
  validates :email, :phone, uniqueness: true
  validates :email, email_format: { message: "doesn't look like an email address" }
  validate :birthday_cannot_be_less_than_21

  def birthday_cannot_be_less_than_21
    if ((Date.today - birthday.to_date) / 365.25) < 21.00
      errors.add(:birthday, "can't be less than 21")
    end
  end
end

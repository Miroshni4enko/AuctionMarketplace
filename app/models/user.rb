# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  birthday               :date             not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  last_name              :string           not null
#  phone                  :string           not null
#  provider               :string           default("email"), not null
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :confirmable
  include DeviseTokenAuth::Concerns::User
  has_many :lots, dependent: :destroy, inverse_of: :user
  has_many :bids, dependent: :destroy

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

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

class User < ApplicationRecord
  has_many :lots, dependent: :destroy, inverse_of: :user
  has_many :bids, dependent: :destroy

  validates :email, :phone, :first_name, :last_name, :birth_day, presence: true
  validates :email, :phone, uniqueness: true
  validates :email, email_format: { message: "doesn't look like an email address" }
  validate :birth_day_must_be_more_than_21

  def birth_day_cannot_be_less_than_21
    if ((birth_day.to_date - Date.today) / 365.25) < 21.00
      errors.add(:birth_day, "can't be less than 21")
    end
  end
end

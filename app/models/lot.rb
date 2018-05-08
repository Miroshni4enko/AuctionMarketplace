# == Schema Information
#
# Table name: lots
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  title           :text             not null
#  image           :string
#  description     :text
#  status          :integer          default("pending"), not null
#  created_at      :datetime         not null
#  current_price   :float            not null
#  estimated_price :float            not null
#  lot_start_time  :datetime         not null
#  lot_end_time    :datetime         not null
#

class Lot < ApplicationRecord
  belongs_to :user
  has_one :order, through: :bid
  has_many :bids, dependent: :destroy, inverse_of: :lot

  enum status: %i[pending inProcess closed]
  validates :title, :status, :created_at, :current_price, :estimated_price,
            :lot_start_time, :lot_end_time, presence: true
  validates :current_price, :estimated_price,
            numericality: {greater_than_or_equal_to: 0}

  validate :lot_start_time_cannot_be_in_the_past,
           :lot_end_time_cannot_be_less_than_lot_start_time

  def lot_start_time_cannot_be_in_the_past
    if lot_start_time < DateTime.now
      errors.add(:lot_start_time, "can't be in the past")
    end
  end

  def lot_end_time_cannot_be_less_than_lot_start_time
    if lot_end_time <= lot_start_time
      errors.add(:lot_end_time, "can't be less lot start time")
    end
  end
end

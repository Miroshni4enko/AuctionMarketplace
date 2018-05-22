# frozen_string_literal: true

# == Schema Information
#
# Table name: lots
#
#  id              :bigint(8)        not null, primary key
#  user_id         :bigint(8)
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
  mount_uploader :image, LotImageUploader
  belongs_to :user
  has_one :order, through: :bid
  has_many :bids, dependent: :destroy, inverse_of: :lot

  enum status: { pending: 0, in_process: 1, closed: 2 }
  validates :title, :status, :current_price, :estimated_price,
            :lot_start_time, :lot_end_time, presence: true
  validates :current_price, :estimated_price,
            numericality: { greater_than_or_equal_to: 0 }
  validates :lot_start_time, times_in_the_future: true

  validate :lot_end_time_cannot_be_less_than_lot_start_time

  def lot_end_time_cannot_be_less_than_lot_start_time
    if lot_end_time.present? && lot_start_time.present? && lot_end_time <= lot_start_time
      errors.add(:lot_end_time, "can't be less lot start time")
    end
  end

  #configure image uploader
  attr_accessor :image, :image_cache, :remove_image
  validates :image, file_size: { less_than: 1.megabytes }
  validates_integrity_of  :image
  validates_processing_of :image
end

# frozen_string_literal: true

# == Schema Information
#
# Table name: lots
#
#  id                 :bigint(8)        not null, primary key
#  current_price      :float            not null
#  description        :text
#  estimated_price    :float            not null
#  image              :string
#  lot_end_time       :datetime         not null
#  lot_jid_closed     :string
#  lot_jid_in_process :string
#  lot_start_time     :datetime         not null
#  status             :integer          default("pending"), not null
#  title              :text             not null
#  winning_bid        :integer
#  created_at         :datetime         not null
#  user_id            :bigint(8)
#
# Indexes
#
#  index_lots_on_user_id  (user_id)
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

  # configure image uploader
  validates :image, file_size: { less_than: 1.megabytes }
  validates_integrity_of :image
  validates_processing_of :image

  validate :lot_end_time_cannot_be_less_than_lot_start_time
  validate :created_status, on: :create

  after_create :create_jobs!
  before_update :check_start_and_end_time


  def lot_end_time_cannot_be_less_than_lot_start_time
    if lot_end_time.present? && lot_start_time.present? && lot_end_time <= lot_start_time
      errors.add(:lot_end_time, "can't be less lot start time")
    end
  end

  def created_status
    if status != "pending"
      errors.add(:status, "must be pending")
    end
  end

  def check_start_and_end_time
    if lot_start_time_changed?
      create_status_job! :in_process
    end

    if lot_end_time_changed?
      create_status_job! :closed
    end
  end

  def self.matching_filter_by_user(filter, user)
    if filter
      if filter == "created"
        user.lots
      elsif filter == "participation"
        joins(:bids).where(bids: { user_id: user.id })
      elsif filter == "all"
        left_joins(:bids)
            .where("lots.user_id": user.id)
            .or(left_joins(:bids).where("bids.user_id": user.id))
      end
    end
  end

  scope :get_to_show, -> (lot_id, user) {
    where(id: lot_id)
        .where(user_id: user.id)
        .or(Lot.where(status: :in_process))
        .left_joins(:bids)
        .or(Lot.left_joins(:bids).where("bids.user_id": user.id))
  }

  scope :pending_lot_by_user, -> (lot_id, user) {
    where(id: lot_id)
        .where(user_id: user.id)
        .where(status: :pending)
  }

  def check_estimated_prices(bid)
    if (bid.proposed_price >= self.estimated_price)
      self.lot_jid_closed = nil
      self.status = :closed
      save
    end
  end


  def create_status_job! (status)
    job = create_status_job status
    if status == :in_process
      update_column(:lot_jid_in_process, job)
    elsif status == :closed
      update_column(:lot_jid_closed, job)
    end
  end


  def create_status_job (status)
    if status == :in_process
      LotStatusUpdateWorker.perform_at(lot_start_time, id, status)
    elsif status == :closed
      LotStatusUpdateWorker.perform_at(lot_end_time, id, status)
    end
  end

  def create_jobs!
    to_in_process_job = create_status_job :in_process
    to_close_job = create_status_job :closed
    update_columns(lot_jid_in_process: to_in_process_job, lot_jid_closed: to_close_job)
  end
end

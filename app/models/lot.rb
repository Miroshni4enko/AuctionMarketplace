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

  validate :lot_end_time_cannot_be_less_than_lot_start_time

  def lot_end_time_cannot_be_less_than_lot_start_time
    if lot_end_time.present? && lot_start_time.present? && lot_end_time <= lot_start_time
      errors.add(:lot_end_time, "can't be less lot start time")
    end
  end

  # configure image uploader
  validates :image, file_size: { less_than: 1.megabytes }
  validates_integrity_of :image
  validates_processing_of :image

  before_destroy :delete_jobs
  after_create :create_jobs
  before_update :check_start_and_end_time

  def delete_jobs
    delete_status_job :in_process
    delete_status_job :closed
  end


  def create_jobs
    create_status_job :in_process
    create_status_job :closed
  end

  def create_status_job(updated_status)
    job = LotStatusUpdateWorker.perform_at(lot_end_time, id, updated_status)
    if updated_status == :closed
      self.lot_jid_closed = job
    end

    if updated_status == :in_process
      self.lot_jid_in_process = job
    end
    save
  end

  def delete_status_job(updated_status)
    scheduled = Sidekiq::ScheduledSet.new.select
    if updated_status == :closed
      job = scheduled.find_job(lot_jid_closed)
    end

    if updated_status == :in_process
      job = scheduled.find_job(lot_jid_in_process)
    end
    job.delete if job
  end

  def update_status_job(updated_status)
    delete_status_job(updated_status)
    create_status_job(updated_status)
  end

  def check_start_and_end_time
    if lot_start_time_changed?
      update_status_job :in_process
    end

    if lot_end_time_changed?
      update_status_job :closed
    end
  end
end

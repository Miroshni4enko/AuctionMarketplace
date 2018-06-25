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
#  winner             :integer
#  winning_bid        :integer
#  created_at         :datetime         not null
#  user_id            :bigint(8)
#
# Indexes
#
#  index_lots_on_user_id  (user_id)
#

class Lot < ApplicationRecord
  include Filterable

  mount_uploader :image, LotImageUploader

  belongs_to :user
  has_one :order, dependent: :destroy
  has_many :bids, dependent: :destroy, inverse_of: :lot

  enum status: {pending: 0, in_process: 1, closed: 2}

  scope :created_criteria, -> {where user_id: User.current.id}

  scope :participation_criteria, -> {joins(:bids).where(bids: {user_id: User.current.id}).distinct}

  scope :all_criteria, -> {where(lots: {user_id: User.current.id})
                               .or(where(bids: {user_id: User.current.id}))
                               .left_joins(:bids)}

  validates :title, :status, :current_price, :estimated_price,
            :lot_start_time, :lot_end_time, presence: true
  validates :current_price, :estimated_price,
            numericality: {greater_than_or_equal_to: 0}
  validates :lot_start_time, times_in_the_future: true

  # configure image uploader
  validates :image, file_size: {less_than: 1.megabytes}
  validates_integrity_of :image
  validates_processing_of :image

  validate :end_time_cannot_be_less_than_start_time
  validate :created_status_validation, on: :create

  after_commit :create_jobs!, on: :create
  before_update :update_jobs_by_start_and_end_time

  def close_lot
    self.lot_jid_closed = nil
    self.status = :closed
    save!
  end

  private

  def update_jobs_by_start_and_end_time
    if lot_start_time_changed?
      create_updated_status_job! :in_process, lot_start_time
    end

    if lot_end_time_changed?
      create_updated_status_job! :closed, lot_end_time
    end
  end

  def end_time_cannot_be_less_than_start_time
    if lot_end_time.present? && lot_start_time.present? && lot_end_time <= lot_start_time
      errors.add(:lot_end_time, "can't be less lot start time")
    end
  end

  def create_updated_status_job! (status, time)
    job = create_updated_status_job status, time
    update_column("lot_jid_#{status}", job)
  end

  def create_updated_status_job (status, time)
    LotStatusUpdateWorker.perform_at(time, id, status)
  end

  def create_jobs!
    to_in_process_job = create_updated_status_job :in_process, lot_start_time
    to_close_job = create_updated_status_job :closed, lot_end_time
    update_columns(lot_jid_in_process: to_in_process_job, lot_jid_closed: to_close_job)
  end
end

# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id               :bigint(8)        not null, primary key
#  arrival_location :text             not null
#  arrival_type     :integer          default("pickup"), not null
#  status           :integer          default("pending"), not null
#  lot_id           :bigint(8)
#
# Indexes
#
#  index_orders_on_lot_id  (lot_id)
#

class Order < ApplicationRecord
  belongs_to :lot
  enum status: { pending: 0, sent: 1, delivered: 2 }
  validates :arrival_location, :arrival_type, :status, presence: true
  enum arrival_type: { pickup: 0, "Royal Mail" => 1, "United States Postal Service" => 2,
                       "DHL Express" => 3 }

  validate :created_status_validation, on: :create
  validate :status_pending_and_not_changed, on: :update
  validate :status_changes, on: :update

    def status_pending_and_not_changed
      if changed != ["status"] && status != "pending"
        errors.add(:status, "can't update order if status is not pending")
      end
    end

    def status_changes
      if status_changed? && status_change != ["pending", "sent"] && status_change != ["sent", "delivered"]
        errors.add(:status, "status should be update only from pending to sent or from sent to delivered")
      end
    end

end

# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id               :bigint(8)        not null, primary key
#  arrival_location :text             not null
#  arrival_type     :integer          default("pickup"), not null
#  status           :integer          default("pending"), not null
#  bid_id           :bigint(8)
#
# Indexes
#
#  index_orders_on_bid_id  (bid_id)
#

class Order < ApplicationRecord
  belongs_to :bid

  enum status: { pending: 0, sent: 1, delivered: 2 }
  validates :arrival_location, :arrival_type, :status, presence: true
  enum arrival_type: { pickup: 0, "Royal Mail" => 1, "United States Postal Service" => 2,
                       "DHL Express" => 3 }
end

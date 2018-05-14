# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id               :bigint(8)        not null, primary key
#  bid_id           :bigint(8)
#  arrival_location :text             not null
#  arrival_type     :integer          default("pickup"), not null
#  status           :integer          default("pending"), not null
#

class Order < ApplicationRecord
  belongs_to :bid

  enum status: { pending: 0, sent: 1, delivered: 2 }
  validates :arrival_location, :arrival_type, :status, presence: true
  enum arrival_type: { pickup: 0, 'Royal Mail'.to_sym => 1, 'United States Postal Service'.to_sym => 2,
                       'DHL Express'.to_sym => 3 }
end

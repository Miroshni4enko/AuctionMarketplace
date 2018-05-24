# frozen_string_literal: true

# == Schema Information
#
# Table name: bids
#
#  id             :bigint(8)        not null, primary key
#  user_id        :bigint(8)
#  lot_id         :bigint(8)
#  created_at     :datetime         not null
#  proposed_price :float            not null
#

class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :lot
  has_one :order, dependent: :destroy
  validates :proposed_price, presence: true
  validates :proposed_price, numericality: { greater_than_or_equal_to: 0 }
end

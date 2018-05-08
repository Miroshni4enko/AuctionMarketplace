# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  bid_id           :integer
#  arrival_location :text             not null
#  arrival_type     :string           not null
#  status           :integer          not null
#

class Order < ApplicationRecord
  belongs_to :bid

  enum status: %i[pending sent delivered]
  validates :arrival_location, :arrival_type, :status, presence: true
end

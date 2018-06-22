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

class OrderSerializer < ActiveModel::Serializer
  attributes :id, :arrival_type, :arrival_location
end

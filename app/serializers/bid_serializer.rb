# frozen_string_literal: true

# == Schema Information
#
# Table name: bids
#
#  id             :bigint(8)        not null, primary key
#  proposed_price :float            not null
#  created_at     :datetime         not null
#  lot_id         :bigint(8)
#  user_id        :bigint(8)
#
# Indexes
#
#  index_bids_on_lot_id   (lot_id)
#  index_bids_on_user_id  (user_id)
#


class BidSerializer < ActiveModel::Serializer
  attributes :id, :customer_name, :proposed_price, :created_at

  def customer_name
    if object.user_id == @instance_options[:current_user_id]
      "You"
    else
      user_hash = Digest::SHA256.hexdigest("#{object.lot_id} + #{object.user_id}")
      "Customer  #{user_hash}"
    end
  end
end

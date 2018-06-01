# frozen_string_literal: true

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

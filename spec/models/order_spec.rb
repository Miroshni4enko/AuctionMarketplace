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

require 'rails_helper'

RSpec.describe Order, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

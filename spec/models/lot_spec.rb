# == Schema Information
#
# Table name: lots
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  title           :text             not null
#  image           :string
#  description     :text
#  status          :integer          default("pending"), not null
#  created_at      :datetime         not null
#  current_price   :float            not null
#  estimated_price :float            not null
#  lot_start_time  :datetime         not null
#  lot_end_time    :datetime         not null
#

require 'rails_helper'

RSpec.describe Lot, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

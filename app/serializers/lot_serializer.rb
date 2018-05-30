# frozen_string_literal: true
# == Schema Information
#
# Table name: lots
#
#  id                 :bigint(8)        not null, primary key
#  current_price      :float            not null
#  description        :text
#  estimated_price    :float            not null
#  image              :string
#  lot_end_time       :datetime         not null
#  lot_jid_closed     :string
#  lot_jid_in_process :string
#  lot_start_time     :datetime         not null
#  status             :integer          default("pending"), not null
#  title              :text             not null
#  winning_bid        :integer
#  created_at         :datetime         not null
#  user_id            :bigint(8)
#
# Indexes
#
#  index_lots_on_user_id  (user_id)
#

class LotSerializer < ActiveModel::Serializer
  attributes :id, :image, :title, :description, :current_price, :created_at,
             :estimated_price, :lot_start_time, :lot_end_time, :status
end

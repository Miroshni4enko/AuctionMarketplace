# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           not null
#  phone                  :string           not null
#  first_name             :string           not null
#  last_name              :string           not null
#  birthday               :date             not null
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  allow_password_change  :boolean          default(FALSE)
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  tokens                 :json
#

require 'rails_helper'
RSpec.describe User, type: :model do
  describe '#birthday' do
    it 'should validate that age more than 21' do
      mock_user = User.new birthday: Date.parse('2000-12-03').to_date
      mock_user.valid?
      expect(mock_user.errors[:birthday]).to include("can't be less than 21")
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  email      :string           not null
#  phone      :string           not null
#  first_name :string           not null
#  last_name  :string           not null
#  birthday   :date             not null
#

require 'rails_helper'
RSpec.describe User, :type => :model do

  describe '#birthday' do

    it 'should validate that age more than 21' do
      mock_user = User.new  birthday: Date.parse("2000-12-03").to_date
      mock_user.valid?
      expect(mock_user.errors[:birthday]).to include("can't be less than 21")
    end

  end

end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserController, type: :controller do
  before(:each) do
    @current_user = FactoryBot.create(:random_user)
  end
  describe 'GET #members_only ' do
    it "doesn't give you anything if you don't log in" do
      get :members_only
      expect(response).to have_http_status(401)
    end

    it 'get success result after sign_in' do
      get '/user/members_only', headers: token_sign_in(@current_user)
      expect(response).to have_http_status(:success)
    end
  end
  def token_sign_in user
    return user.create_new_auth_token
  end
end

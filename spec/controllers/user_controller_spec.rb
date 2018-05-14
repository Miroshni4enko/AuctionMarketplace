# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserController, type: :controller do
  describe 'GET #members_only ' do
    it "doesn't give you anything if you don't log in" do
      get :members_only
      expect(response).to have_http_status(401)
    end

    it 'get success result after sign_in' do
      current_user = FactoryBot.create(:random_user)
      request.headers.merge! current_user.create_new_auth_token
      get :members_only
      expect(response).to be_successful
    end
  end

end

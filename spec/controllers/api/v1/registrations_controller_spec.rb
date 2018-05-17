# frozen_string_literal: true

require "rails_helper"

describe "Sign up user flow  ", type: :request do
  let!(:user_params) {
    user_params = FactoryBot.attributes_for(:random_user_with_success_url_for_sign_up)
  }


  describe "Post #create" do
    it "should create user" do
      post "/api/v1/auth", params: user_params
      expect(response).to be_successful
    end

    it "sends confirmation instructions" do
      expect { post "/api/v1/auth", params: user_params }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end

  describe "Delete #destroy" do
    current_user = FactoryBot.create(:confirmed_random_user)
    it "should destroy user" do
      delete "/api/v1/auth", params: { email: current_user.email, password: current_user.password }, headers: current_user.create_new_auth_token
      # Rails.logger.debug JSON.parse(response.body).to_hash["errors"]
      expect(response).to be_successful
    end
  end


end

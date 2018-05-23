# frozen_string_literal: true

require "rails_helper"

describe "Sign up user flow  ", type: :request do
  let!(:user_params) {
    user_params = FactoryBot.attributes_for(:user, :unconfirmed)
  }


  describe "Post #create" do
    it "should create user" do
      post "/api/auth", params: user_params
      expect(response).to be_successful
    end

    it "sends confirmation instructions" do
      expect { post "/api/auth", params: user_params }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end

  describe "Delete #destroy" do
    it "should destroy user" do
      current_user = FactoryBot.create(:user)
      delete "/api/auth", params: { email: current_user.email, password: current_user.password }, headers: current_user.create_new_auth_token
      # Rails.logger.debug JSON.parse(response.body).to_hash["errors"]
      expect(response).to be_successful
    end
  end


end

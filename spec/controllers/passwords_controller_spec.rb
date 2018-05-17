# frozen_string_literal: true

require "rails_helper"

describe "Password reset", type: :request do
  describe "PUT #edit" do
    before do
      @user = FactoryBot.create(:random_user)
      @new_password = Faker::Internet.password
      put "/auth/password", params: { password: @new_password,
                                     password_confirmation: @new_password },
          headers: @user.create_new_auth_token
      @response_body = JSON.parse(response.body)
      @user.reload
    end

    it "request should be successful" do
      expect(response).to be_successful
    end

    it "request should return success message" do
      expect(@response_body["message"]).to be
      expect(@response_body["message"]).to eq(I18n.t("devise_token_auth.passwords.successfully_updated"))
    end
    it "new password should authenticate user" do
      expect(@user.valid_password?(@new_password)).to be_truthy
    end
  end
end

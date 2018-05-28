# frozen_string_literal: true

require "rails_helper"

describe "Password reset", type: :request do
  describe "POST #create" do
    describe "successfully requested password reset" do
      before do
        @user = FactoryBot.create(:user, :unconfirmed)

        post "/api/auth/password", params: { email: @user.email }

        @mail = ActionMailer::Base.deliveries.last
        @user.reload
        @data = JSON.parse(response.body)

        @mail_config_name = CGI.unescape(@mail.body.match(/config=([^&]*)&/)[1])
        @mail_redirect_url = CGI.unescape(@mail.body.match(/redirect_url=([^&]*)&/)[1])
        @mail_reset_token = @mail.body.match(/reset_password_token=(.*)\"/)[1]
      end
      it "should return success status" do
        expect(response).to be_successful
      end

      it "should send an email" do
        expect(@mail).to be
      end

      it "should be addressed the email to the user" do
        expect(@mail.to.first).to eq(@user.email)
      end

      it "should contain the email body  a link with redirect url as a query param" do
        expect(DeviseTokenAuth.default_password_reset_url).to eq(@mail_redirect_url)
      end

      it "should contain a link with reset token as a query param" do
        user = User.reset_password_by_token(reset_password_token: @mail_reset_token)
        assert_equal user.id, @user.id
      end
    end
  end

  describe "PUT #edit" do
    before do
      @user = FactoryBot.create(:user, :unconfirmed)
      @new_password = Faker::Internet.password
      put "/api/auth/password", params: { password: @new_password,
                                     password_confirmation: @new_password,
                                     current_password: @user.password },
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

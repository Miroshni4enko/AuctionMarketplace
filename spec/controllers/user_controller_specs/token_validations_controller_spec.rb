# frozen_string_literal: true

require "rails_helper"

describe "Token validations", type: :request do
  describe "GET #validate_token" do
    before do
      @user = build(:user, :unconfirmed)
      @user.skip_confirmation!
      @user.save!
      @auth_headers = @user.create_new_auth_token
    end

    describe "success token validation" do
      before do
        get "/api/auth/validate_token", headers: @auth_headers
        @resp = JSON.parse(response.body)
      end

      it "token valid" do
        assert_equal 200, response.status
      end
    end

    describe "failure token validation" do
      before do
        get "/api/auth/validate_token",
            headers: @auth_headers.merge("access-token" => "11111")
        @response_body = JSON.parse(response.body)
      end

      it "request should fail" do
        expect(response).to have_http_status(401)
      end

      it "response should contain errors" do
        expect(@response_body["errors"]).to be
        expect(@response_body["errors"]).to eq([I18n.t("devise_token_auth.token_validations.invalid")])
      end
    end
  end
end
